Set-Variable $global:ProgressPreference SilentlyContinue

Install-WindowsFeature Web-Server -IncludeManagementTools

$filein = 'https://download.visualstudio.microsoft.com/download/pr/7ab0bc25-5b00-42c3-b7cc-bb8e08f05135/91528a790a28c1f0fe39845decf40e10/dotnet-hosting-6.0.16-win.exe'
Invoke-WebRequest -Uri $filein -OutFile "$(pwd)\dotnet-hosting-6.0.16-win.exe"

Start-Process -FilePath "$(pwd)\dotnet-hosting-6.0.16-win.exe" -Wait -ArgumentList /passive

net stop was /y
net start w3svc

# download and unzip the application
$YourBucketName = "<my>-practical-cloud-guide"
$AppKey = "app.zip"
New-Item -Path "C:\inet\newsite" -ItemType Directory
$AppFile = "C:\inet\newsite\" + $AppKey
Copy-S3Object -BucketName $YourBucketName -Key $AppKey -LocalFile $AppFile
Expand-Archive $AppFile -DestinationPath "C:\inet\newsite"

# disable default application poot and application
Stop-WebAppPool -Name "DefaultAppPool"
Stop-WebSite -Name "Default Web Site"

# create application pool
$appPoolName = "DemoAppPool"
New-WebAppPool -Name $appPoolName -force

New-Item IIS:\Sites\DemoSite -physicalPath "C:\inet" -bindings @{protocol="http";bindingInformation=":8080:"}
Set-ItemProperty IIS:\Sites\DemoSite -name applicationPool -value $appPoolName
New-Item IIS:\Sites\DemoSite\DemoApp -physicalPath "C:\inet\newsite" -type Application
Set-ItemProperty IIS:\sites\DemoSite\DemoApp -name applicationPool -value $appPoolName

# start new website
Start-WebAppPool -Name $appPoolName
Start-WebSite -Name "DemoSite"

# open Edge
start microsoft-edge:http://localhost:8080/DemoApp

# remove AWS credentials
Remove-AWSCredentialProfile -ProfileName default