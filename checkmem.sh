#!/bin/bash
PERCENT_ALLOWED=50

test_memory(){
    MAXMEM=$(free | grep "Mem"|awk -F' ' '{print $2}')
    USEDMEM=$(expr `free | grep "Mem"|awk -F' ' '{print $3}'` \* 100)
    PERCENTAGE=$(expr $USEDMEN / $MAXMEM)
    # Si el porcentaje usado es mayor que porcentaje_alerta return 1
    [[ $PERCENTAGE>$PERCENT_ALLOWED ]] && return 1 || return 0
}
if test_memory;
then
  umount /srv/www
  echo "HELP" | ssh ferrete@10.10.10.1 "cat > /home/ferrete/$HOSTNAME"
fi
