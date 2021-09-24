## Set variable
$Pathx86Objs = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$Pathx64Objs = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
#Set yout software installpath
$InstallPath = Get-ChildItem -Path "C:\tmp\"

## Set hashtable
# Set your Software Name, Version and InstallationParam.
$CustomObjs = @()
$CustomObjs += New-Object -TypeName psobject -Property @{'Name'="KeePass Password Safe 2.47"; 'Version'="2.49"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'NeedToUpdate' = $null; 'InstallParam'="/VERYSILENT"}
$CustomObjs += New-Object -TypeName psobject -Property @{'Name'="Mozilla Firefox (x64 en-US)"; 'Version'="92.0"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'NeedToUpdate' = $null; 'InstallParam'="/SILENT"}
$CustomObjs += New-Object -TypeName psobject -Property @{'Name'="MobaXterm"; 'Version'="21.3.0.4736"; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'NeedToUpdate' = $null; 'InstallParam'="/quiet"}

## Play Code (Check if installation found x86 and x64)
foreach($CustomObj in $CustomObjs){
    $CustomObj.InstallationFoundx86 = $false
        foreach($Pathx86Obj in $Pathx86Objs){
            if($Pathx86Obj.DisplayName -eq $CustomObj.Name){
                $CustomObj.InstallationFoundx86 = $true
                if($Pathx86Obj.DisplayVersion -lt $CustomObj.Version){
                    $CustomObj.NeedToUpdate = $true   
            }
        }
     }
    $CustomObj.InstallationFoundx64 = $false
        foreach($Pathx64Obj in $Pathx64Objs){
            if($Pathx64Obj.DisplayName -eq $CustomObj.Name){
                $CustomObj.InstallationFoundx64 = $true
                if($Pathx64Obj.DisplayVersion -lt $CustomObj.Version){
                    $CustomObj.NeedToUpdate = $true
                }
            }
        }
## Output hastable
    $CustomObj
## Install software if update -eq true
    foreach($CustomObjName in $CustomObj.Name){
        $SplitName = ($CustomObjName -split ' ')[0]
        foreach($Installpathobj in $InstallPath){
            if($InstallPathObj.BaseName.Contains($SplitName) -and ($CustomObj.NeedToUpdate -eq $true)){
                Start-Process -FilePath $InstallPathObj.FullName -ArgumentList $CustomObj.InstallParam
                Write-Host "$SplitName installed" -ForegroundColor Green
            }
        }
    }
}
