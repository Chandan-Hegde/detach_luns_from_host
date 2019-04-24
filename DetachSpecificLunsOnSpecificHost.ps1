do
  {
  Write-Host "Enter the name of the ESXi host you want to detach SCSI devices from" `n
  $hostanswer = Read-Host "For Example: esxi-1.localdomain"
  if($hostanswer -eq $null)
	  {
	  Write-Host $hostanswer "Please enter ESXi host name." -ForegroundColor Red
	  }
  }
until($hostanswer)

do
  {
  Write-Host "What is the file name containing the NAA device list?" `n
  $DeviceAnswer = Read-Host "For Example: list.txt"
  if($DeviceAnswer -eq $null)
	  {
	  Write-Host $DeviceAnswer "Please enter file name." -ForegroundColor Red
	  }
  }
until($DeviceAnswer) 

$devicelist = get-content $DeviceAnswer
$vmhost = get-vmhost $hostanswer
$hostview = $vmhost | get-view
$StorageSys = Get-View $HostView.ConfigManager.StorageSystem
$devices = $StorageSys.StorageDeviceInfo.ScsiLun
foreach($CanonicalName in $devicelist)
{
  Foreach ($device in $devices) 
  {
	if ($device.canonicalName -eq $CanonicalName) 
	  {
		$LunUUID = $Device.Uuid
		Write-Host "Detaching LUN $($Device.CanonicalName) from host $($hostview.Name)..."
		Write-host "LUN UUID is $($LunUUID)"
        $StorageSys.DetachScsiLun($LunUUID);
	  }
   }
  
  }
