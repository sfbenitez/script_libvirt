#!/bin/bash
if grep -Fxq "HELP" /home/ferrete/MV1
then
  #deattach
  virsh detach-disk MV1 vdb --live --config
  #aumentar tamaño
  lvresize -L 2G /dev/volumenes1/apache
  #montar local
  mount /dev/volumenes1/apache /mnt/
  #redimensionar-fs
  xfs_growfs /dev/volumenes1/apache
  #desmontar local
  umount /mnt/
  #attach mv2
  virsh attach-disk MV2 --source /dev/vgferrete/apache --target vdb --persistent
  #ejecutar montar en mv2
  ssh root@10.10.10.3 "/root/MV2"
fi

if grep -Fxq "HELP" /home/ferrete/MV2
then
  # resize Mem
  virsh setmem MV2 2G --live
