
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-PackageProvider -Name Nuget -Force

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install microsoft-windows-terminal pwsh -y


Install-Module posh-git -Scope CurrentUser -Confirm:$false
$ProfileDir = Split-Path $PROFILE -parent
Invoke-Webrequest https://github.com/JanDeDobbeleer/oh-my-posh3/releases/latest/download/posh-windows-amd64.exe -OutFile $ProfileDir\oh-my-posh.exe

Copy-Item $PSScriptRoot\Powershell\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE
Copy-Item $PSScriptRoot\henk.json -Destination $ProfileDir

# install font
$objShell = new-object -com shell.application
$objFolder = $objShell.Namespace("$PSScriptRoot")
$objFolderItem = $objFolder.ParseName("Caskaydia Cove Nerd Font Complete.ttf")
$objFolderItem.InvokeVerb("Install")

$ScriptBlock = {
	$terminalFolder = Get-Item "$env:LocalAppData\Packages\Microsoft.WindowsTerminal*"
	$settingsJson = Get-Content "$terminalFolder\LocalState\settings.json" | ConvertFrom-Json

	# Add the colorScheme
	$schemesArray = @()

	Foreach ($scheme in ($settingsjson | Select -Last 1).schemes) {
		$schemeHash = @{};
		foreach ($property in $scheme.psobject.properties) {
			$schemeHash[$property.Name] = $property.Value
		}
		$schemesArray += $schemeHash
	}

	$blueMatrix = @{			
		"name"         = "Blue Matrixx";
		"black"        = "#101116";
		"red"          = "#ff5680";
		"green"        = "#00ff9c";
		"yellow"       = "#fffc58";
		"blue"         = "#00b0ff";
		"purple"       = "#d57bff";
		"cyan"         = "#76c1ff";
		"white"        = "#c7c7c7";
		"brightBlack"  = "#686868";
		"brightRed"    = "#ff6e67";
		"brightGreen"  = "#5ffa68";
		"brightYellow" = "#fffc67";
		"brightBlue"   = "#6871ff";
		"brightPurple" = "#d682ec";
		"brightCyan"   = "#60fdff";
		"brightWhite"  = "#ffffff";
		"background"   = "#1d2342";
		"foreground"   = "#b8ffe1"
	}	

	if (-not ($schemesArray.Contains($blueMatrix))) {
		$schemesArray += $blueMatrix			
	}

	#Weird trick, the json object/array has an empty first member
	($settingsJson | Select -Last 1).schemes = $schemesArray

	#Add the defaults
	$defaultsHash = @{}
	foreach ($property in ($settingsJson | Select -Last 1).profiles.defaults.psobject.properties) {
		$defaultsHash[$property.Name] = $property.Value
	}
	$defaultsHash["colorScheme"] = "Blue Matrixx"
	$defaultsHash["fontFace"] = "CaskaydiaCove Nerd Font"

	($settingsJson | Select -Last 1).profiles.defaults = $defaultsHash


	$settingsJson | Select -Last 1 | ConvertTo-Json -Depth 99 | Set-Content "$terminalFolder\LocalState\settings.json"
}

$bytes = [System.Text.Encoding]::Unicode.GetBytes($ScriptBlock.tostring())
$b64 = [System.Convert]::ToBase64String($bytes)
# start terminal
. wt 
Start-Sleep -Seconds 10

Start-Process -FilePath "$env:ProgramFiles\Powershell\7\pwsh.exe" -ArgumentList "-encodedcommand `"$b64`""