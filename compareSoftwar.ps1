$Pathx86Objs = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$Pathx64Objs = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'

$CustomObjs = @()
$CustomObjs += New-Object -TypeName psobject -Property @{Name="KeePass Password Safe 2.49"; Version="2.49"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'needToUpdate' = $null}
$CustomObjs += New-Object -TypeName psobject -Property @{Name="Mozilla Maintenance Service"; Version="92.0"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'needToUpdate' = $null}
$CustomObjs += New-Object -TypeName psobject -Property @{Name="Mozilla Firefox (x64 en-US)"; Version="92.0"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'needToUpdate' = $null}
$CustomObjs += New-Object -TypeName psobject -Property @{Name="draw.io 15.2.7"; Version="15.2.7"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'needToUpdate' = $null}
$CustomObjs += New-Object -TypeName psobject -Property @{Name="MobaXterm"; Version="21.3.0.4736"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'needToUpdate' = $null}

foreach($CustomObj in $CustomObjs){
  $CustomObj.InstallationFoundx86 = $false
     foreach($Pathx86Obj in $Pathx86Objs){
        if($Pathx86Obj.DisplayName -eq $CustomObj.Name){
            $CustomObj.InstallationFoundx86 = $true
            if($Pathx86Obj.DisplayVersion -lt $CustomObj.Version){
                $CustomObj.needToUpdate = $true
            }
        }
  }

  $CustomObj.InstallationFoundx64 = $false
     foreach($Pathx64Obj in $Pathx64Objs){
        if($Pathx64Obj.DisplayName -eq $CustomObj.Name){
            $CustomObj.InstallationFoundx64 = $true
            if($Pathx64Obj.DisplayVersion -lt $CustomObj.Version){
                $CustomObj.needToUpdate = $true
            }
        }
     }

  $CustomObj

}
