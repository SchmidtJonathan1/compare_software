## Set variable
$Pathx86Objs = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
$Pathx64Objs = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
#Set yout software installpath
$InstallPath = Get-ChildItem -Path "C:\tmp\"

## Set hashtable
# Set your Software Name, Version and InstallationParam.
$hashtable = @{
    'Name' = "Visual Studio Community 2019";
    'Version' = "17.8.30717.126";
    'InstallationFoundx86' = $null;
    'InstallationFoundx64' = $null;
    'needToUpdate' = $null;
    'InstallParam'="/VERYSILENT"
    }
$CustomObj = New-Object -TypeName pscustomobject -Property $hashtable

## Play Code (Check if installation found x86 and x64)
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
