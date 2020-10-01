
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install microsoft-windows-terminal cascadiacodepl -y
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-PackageProvider -Name Nuget -Force -Confirm:$false


Install-Module oh-my-posh,posh-git -Scope CurrentUser -Confirm:$false


Foreach ($Version in $(gci "$(Split-Path $PROFILE -parent)\Modules\oh-my-posh"))
{
	Copy-Item $PSScriptRoot\Powershell\underwear.psm1 -Destination "$($Version.FullName)\Themes"
}
Copy-Item $PSScriptRoot\Powershell\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE
$terminalFolder =  Get-Item "$env:LocalAppData\Packages\Microsoft.WindowsTerminal*"
$settingsJson = Get-Content "$terminalFolder\LocalState\settings.json" | ConvertFrom-Json -Depth 99

# Add the colorScheme
$schemesArray = @()

Foreach ($scheme in ($settingsjson | Select -Last 1).schemes) 
{
	$schemeHash = @{};
	foreach ($property in $scheme.psobject.properties)
	{
		$schemeHash[$property.Name] = $property.Value
	}
	$schemesArray += $schemeHash
}

$blueMatrix = @{			
	"name"= "Blue Matrixx";
	"black"= "#101116";
	"red"= "#ff5680";
	"green"= "#00ff9c";
	"yellow"= "#fffc58";
	"blue"= "#00b0ff";
	"purple"= "#d57bff";
	"cyan"= "#76c1ff";
	"white"= "#c7c7c7";
	"brightBlack"= "#686868";
	"brightRed"= "#ff6e67";
	"brightGreen"= "#5ffa68";
	"brightYellow"= "#fffc67";
	"brightBlue"= "#6871ff";
	"brightPurple"= "#d682ec";
	"brightCyan"= "#60fdff";
	"brightWhite"= "#ffffff";
	"background"= "#1d2342";
	"foreground"= "#b8ffe1"
}	

if (-not ($schemesArray.Contains($blueMatrix)))
{
	$schemesArray += $blueMatrix			
}

#Weird trick, the json object/array has an empty first member
($settingsJson | Select -Last 1).schemes = $schemesArray

#Add the defaults
$defaultsHash = @{}
foreach ($property in ($settingsJson | Select -Last 1).profiles.defaults.psobject.properties)
{
		$defaultsHash[$property.Name] = $property.Value
}
$defaultsHash["colorScheme"] = "Blue Matrixx"
$defaultsHash["fontFace"] = "Cascadia Code PL"

($settingsJson | Select -Last 1).profiles.defaults = $defaultsHash


$settingsJson | Select -Last 1 | ConvertTo-Json -Depth 99 | Set-Content "$terminalFolder\LocalState\settings.json"


