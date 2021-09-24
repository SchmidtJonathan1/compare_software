## Set parameter mandatory
param([Parameter(Mandatory)][string]$SoftwareName, 
      [Parameter(Mandatory)][string]$SoftwareVersion, 
      [Parameter(Mandatory)][string]$SoftwareParam,
      [Parameter(Mandatory)][string]$FolderPath)

## Set variable
# Regpath
$Pathx86Objs = Get-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$Pathx64Objs = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'

#Set yout software installpath
$InstallPath = Get-ChildItem -Path $FolderPath

## Set hashtable
# Set your Software Name, Version and InstallationParam.
$CustomObjs = @()

## Play Code (Check if installation found x86 and x64)
# Split name and get real name from registry
$SplitName = ($SoftwareName -split ' ')[0]
foreach($Pathx86Obj in $Pathx86Objs){
    if($Pathx86Obj.DisplayName.Contains($SplitName)){         
        $CheckRegName = $Pathx86Obj.DisplayName
        $CustomObjs += New-Object -TypeName psobject -Property @{'Name'=$CheckRegName ; 'Version'=$SoftwareVersion; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'NeedToUpdate' = $null; 'InstallParam'=$SoftwareParam}
    }
}

foreach($Pathx64Obj in $Pathx64Objs){
    if($Pathx64Obj.DisplayName.Contains($SplitName)){         
        $CheckRegName = $Pathx64Obj.DisplayName
        $CustomObjs += New-Object -TypeName psobject -Property @{'Name'=$CheckRegName ; 'Version'=$SoftwareVersion; 'InstallationFoundx86'= $null; 'InstallationFoundx64' = $null; 'NeedToUpdate' = $null; 'InstallParam'=$SoftwareParam}
    }
}

# Check if object exist in regpath
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

# Output hastable
    $CustomObj

# Install software if update -eq true
    foreach($CustomObjName in $CustomObj.Name){
        $SplitName = ($CustomObjName -split ' ')[0]
        foreach($Installpathobj in $InstallPath){
            if($InstallPathObj.BaseName.Contains($SplitName) -and ($CustomObj.NeedToUpdate -eq $true)){
                #Start-Process -FilePath $InstallPathObj.FullName -ArgumentList $CustomObj.InstallParam
                Write-Host "$SplitName installed" -ForegroundColor Green
            }
        }
    }
}
