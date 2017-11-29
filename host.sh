#!/bin/bash
# Comprobar si necesita ayuda MV1
if grep -Fxq "HELP" /root/mv1;
then
  # Quitar disco a MV1 en caliente
  virsh detach-disk MV1 vdb --live
  # Redimensionar el volumen de la aplicación
  lvresize -L 2G /dev/volumenes1/apache
  # Motar volumen en local para poder redimensionar el sistema de ficheros
  mount /dev/volumenes1/apache /mnt/
  # Redimesionar el sistema de ficheros
  xfs_growfs /dev/volumenes1/apache
  # Desmontar el volumen
  umount /mnt/
  # Añadir el volumen a MV2 en caliente
  virsh attach-disk MV2 --source /dev/volumenes1/apache --target vdb --live
  # Eliminar regla iptables redirigida hacia MV1 y añadir una regla dirigida hacia MV2
  iptables -t nat -D PREROUTING -i br0 -p tcp --dport 80 -j DNAT --to 10.10.10.2:80
  iptables -t nat -A PREROUTING -i br0 -p tcp --dport 80 -j DNAT --to 10.10.10.3:80
  # Montar el volumen en MV2
  ssh root@10.10.10.3 "/root/mount_disk.sh"
  # Elimiar el fichero de ayuda
  rm /root/mv1
fi
# Comprobar si necesita ayuda MV2
if grep -Fxq "HELP" /root/mv2;
then
  # Redimensionar la memoria actual de MV2
  virsh setmem MV2 2G --live
  # Eliminar el fichero de ayuda
  rm /root/mv2
fi
# stress memory MV1: stress -m 1 --vm-bytes 420M --vm-keep -t 70s
# stress memory MV2: stress -m 1 --vm-bytes 840M --vm-keep -t 70s
