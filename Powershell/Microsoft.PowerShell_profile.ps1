$ipaddress = [System.Net.DNS]::GetHostByName($null)

foreach ($ip in $ipaddress.AddressList) {
    if ($ip.AddressFamily -eq 'InterNetwork') {
        $ModernConsole_IPv4Address = $ip.IPAddressToString
        break
    }
}
function explorer {
    explorer.exe .
}

set-alias unzip expand-archive
Set-Alias -Name firefox -Value "C:\Program Files\Mozilla Firefox\firefox.exe" -Description "Launches Firefox" -Force -ErrorAction SilentlyContinue
Set-Alias -Name VSIE -Value "C:\Users\markp\OneDrive\LoginVSI\ScriptEditor\ScriptEditor.exe" -Description "Launches LoginVSI Script Editor" -Force

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
   PSVersion        :  "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor).$($PSVersionTable.PSVersion.Build).$($PSVersionTable.PSVersion.Revision)"                              
   Date & Time      :  $(Get-Date -Format F)         
                                                                  
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

"@

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme underwear
write-host $dets -NoNewline