$ipaddress = [System.Net.DNS]::GetHostByName($null)

foreach ($ip in $ipaddress.AddressList) {
    if ($ip.AddressFamily -eq 'InterNetwork') {
        $ModernConsole_IPv4Address = $ip.IPAddressToString
        break
    }
}

$dets = @"

+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
           _.-'~~~~~~`-._
          /      ||      \
         /       ||       \
        |        ||        |
        | _______||_______ |
        |/ ----- \/ ----- \|
       /  (     )  (     )  \
      / \  ----- () -----  / \
     /   \      /||\      /   \
    /     \    /||||\    /     \
   /       \  /||||||\  /       \
  /_        \o========o/        _\
    `--...__|`-._  _.-'|__...--'
            |    `'    |             

   Domain\Username  :  $env:USERDOMAIN\$env:USERNAME              
   Hostname         :  $([System.Net.Dns]::GetHostEntry([string]$env:computername).HostName)                            
   IPv4-Address     :  $ModernConsole_IPv4Address                             
   PSVersion        :  $($PSVersionTable.PSVersion.ToString())                              
   Date & Time      :  $(Get-Date -Format F)         
                                                                  
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

"@
$global:ErrorCount = 0
#Import-Module posh-git
[ScriptBlock]$Prompt = {
    $lastCommandFailed = ($global:error.Count -gt $global:ErrorCount) -or -not $?
    if ($lastCommandFailed) {$env:ERROR="x"} else {$env:ERROR=""}
    $global:ErrorCount = $global:error.Count
    $realLASTEXITCODE = $global:LASTEXITCODE
    if ($realLASTEXITCODE -isnot [int]) {
        $realLASTEXITCODE = 0
    }
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "$PSScriptRoot\oh-my-posh.exe"
    $cleanPWD = $PWD.ProviderPath.TrimEnd("\")
    $startInfo.Arguments = "-config=""$PSScriptRoot\henk.json"" -error=$realLASTEXITCODE -pwd=""$cleanPWD"""
    $startInfo.Environment["TERM"] = "xterm-256color"
    $startInfo.CreateNoWindow = $true
    $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $startInfo.RedirectStandardOutput = $true
    $startInfo.UseShellExecute = $false
    if ($PWD.Provider.Name -eq 'FileSystem') {
        $startInfo.WorkingDirectory = $PWD.ProviderPath
    }
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $standardOut = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $standardOut
    $global:LASTEXITCODE = $realLASTEXITCODE
    Remove-Variable realLASTEXITCODE -Confirm:$false
}
Set-Item -Path Function:prompt -Value $Prompt -Force

write-host $dets -NoNewline