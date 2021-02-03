$targetServiceMap = @{
  "Easy Anticheat" = "EasyAntiCheat"
  "BattleEye" = "beservice"
}

foreach ($serviceKey in $targetServiceMap.Keys) {
  $serviceName = $targetServiceMap[$key]
  $message = "Processing service {0} ({1}) " -f $key, $serviceName
  Write-Host "Processing service $serviceKey($serviceName)"   
  $cimInstanceParams = @{
      ClassName = "Win32_Service"
      filter = "Name= '{0}'" -f $serviceName
  }      
  $servicePayload = get-ciminstance @cimInstanceParams
  If ($servicePayload -ne $null) {    
    Write-Host "Service $serviceKey ($serviceName) exists. Attempting removal..."
    $result = remove-ciminstance -InputObject $servicePayload
    Write-Host "Service $serviceKey ($serviceName) removal request completed"
  }
  else {
    Write-Host "Service $serviceKey ($serviceName) not found. No action needed."
  }  
}

Read-Host -Prompt "Press Enter to exit"