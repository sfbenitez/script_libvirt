#!/bin/bash
PERCENT_ALLOWED=90

test_memory(){
    MAXMEM=$(free | grep "Mem"|awk -F' ' '{print $2}')
    USEDMEM=$(expr `free | grep "Mem"|awk -F' ' '{print $3}'` \* 100)
    PERCENTAGE=$(expr $USEDMEM / $MAXMEM)
    # Si el porcentaje usado es mayor que porcentaje_alerta return 1
    [[ $PERCENTAGE>$PERCENT_ALLOWED ]] && return 0 || return 1
}
if test_memory;
then
  umount /srv/www # comented in mv2
  echo "HELP" | ssh root@10.10.10.1 "cat > /root/$HOSTNAME"
fi
