#this Menu use sub-menu so you can input each choices for their cmdlet function  
 $input = Read-Host -Prompt " 
   ==================MENU=========================
   A. Press 'A' Install/Turn On Windows Service.
   B. Press 'B' Turn off/Delete Windows Service.
   C. Press 'C' Initialize Task Scheduler.
   D. Press 'D' Define all attributes as in list of a file 
   Q. Press 'Q' to quit 
    Please select a letter"
   
   switch($input){
   A{Function Installing-Service {
Param ([string]$serviceName ="Com382 Service",
[string] $binaryPath = "C:\Users\pinay\HtmlDownloader.exe http:\\www.amazon.com", [string]$description = "Download Source from Amazon")
      
     
        Write-Host "Creating service: $serviceName"

        # Creating Windows Service using all provided parameters
        Write-Host "Installing service: $serviceName"
        New-Service -name $serviceName -binaryPathName $binaryPath  -displayName $serviceName -Description $description 

        Write-Host "Installation completed: $serviceName"
}

#start a service
Function Start-Service {
    Param(
        [string]$serviceName = "Com382 Service",
        [int]$SecondsToWait = 3
    )
 
    $DependentServices = (Get-Service -Name $serviceName -ErrorAction SilentlyContinue).DependentServices | Where { Get-WmiObject win32_service -Filter "name = '$($_.Name)' and StartMode = 'auto'" }
    If ($DependentServices -ne $null) {
        ForEach ($DependentService in $DependentServices) {
            Start-Service $DependentService.Name -ErrorAction SilentlyContinue
        }
    }
    Start-Service -Name $serviceName -ErrorAction SilentlyContinue
    $ServiceStateCorrect = Wait-ServiceState $serviceName "Running" $SecondsToWait
 
    If ($ServiceStateCorrect) {
        Return $True
    } else {
        Return $false
    }
    }
    }
    

#stop service and delete Service
   B{ Function Stop-Service {
   Param(
        [string]$serviceName = "Com382 Service")

   Write-Host "Unistalling"
     sc.exe STOP $serviceName

     Write-Host "Deleteng Service"
     sc.exe DELETE $serviceName 
     Write-Host "Run the cmdlet Register-Schedule to create task schedule"}}
   

   C{Function Register-Schedule {
    
   $action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
   -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path c:\fso\applog.csv -Force -NoTypeInformation}"'
$trigger =  New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Screen scraping" -Description "Daily dump of "}
Write-Host "Run the cmdlet Register-Schedule to create task schedule"
}
   D { Function Define-Attribute {
    
   Param( [string] $filepath = "C:\Users\pinay\Cities.txt") 
  Write-Host "Run the cmdlet Define-Attribute to view the attribute file"

   Get-Item -Path $filepath 
(Get-Item $filepath).Name #Cities.txt
(Get-Item $filepath).BaseName #Cities
(Get-Item $filepath).Attributes #Archive 

}
}

   Q {Function Exit-Window{exit} Write-Host "Run the cmdlet Exit-Window to close the application"}
  
    
   
   }