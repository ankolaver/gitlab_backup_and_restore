$disk = "$env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx"

write-output "Disk to compact: $($disk)"

wsl --shutdown

$DISKPARTCMD = @"
select vdisk file=$disk
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@
	
$DISKPARTCMD | diskpart