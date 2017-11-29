#!/bin/bash
if grep -Fxq "HELP" /root/mv1;
then
  #deattach
  virsh detach-disk MV1 vdb --live
  #aumentar tamaño
  lvresize -L 2G /dev/volumenes1/apache
  #montar local
  mount /dev/volumenes1/apache /mnt/
  #redimensionar-fs
  xfs_growfs /dev/volumenes1/apache
  #desmontar local
  umount /mnt/
  #attach mv2
  virsh attach-disk MV2 --source /dev/volumenes1/apache --target vdb --live
  #ejecutar montar en mv2
  ssh root@10.10.10.3 "/root/mount_disk.sh"
  rm /root/mv1
fi

if grep -Fxq "HELP" /root/mv2;
then
  # resize Mem
  virsh setmem MV2 2G --live
  rm /root/mv2
fi
# stress memory MV1 stress -m 1 --vm-bytes 420M --vm-keep -t 70s
# stress memory MV2 stress -m 1 --vm-bytes 840M --vm-keep -t 70s
