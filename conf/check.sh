#!/bin/ash
curl -s "http://$1:$2/validphone.php?ctype=json&ani=1139771000" | grep "\"PIPU\":\"113977\"" >/dev/null
echo -n $?
