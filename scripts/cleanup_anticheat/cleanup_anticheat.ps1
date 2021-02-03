$targetServiceMap = @{
  "Easy Anticheat" = "EasyAntiCheat"
  "BattleEye" = "beservice"
}

foreach ($key in $targetServiceMap.Keys) {
  $serviceName = $targetServiceMap[$key]
  $message = "Processing service {0}({1})" -f $key, $serviceName
  Write-Output $message    
  $cimInstanceParams = @{
      ClassName = "Win32_Service"
      filter = "Name= '{0}'" -f $serviceName
  }      
  $serviceAvailable = get-ciminstance @cimInstanceParams
  Write-Output $serviceAvailable
}

# $EasyAntiCheat = get-ciminstance win32_service -filter "name='EasyAntiCheat'" 
#If ($EasyAntiCheat -ne $null) {
  #Write-Output "EasyAnticheat service found"
#}
#else {
#    Write-Output "EasyAnticheat service not found"
#}
# remove-ciminstance -InputObject $EasyAntiCheat
# Write-Host $Result.ExitCode
# $BattleEye = get-ciminstance win32_service -filter "name='beservice'" 
# remove-ciminstance -InputObject $BattleEye
# Write-Host $Result.ExitCode

# Read-Host -Prompt "Press Enter to exit"