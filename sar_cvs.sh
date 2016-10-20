#!/bin/sh

STARTDAY=01
ENDDAY=10

# CPU
function cpu {

for i in $(seq -f "%02g" $STARTDAY $ENDDAY); do
    sar -p -f /var/log/sa/sa$i | grep -v 'Average'| awk 'BEGIN {OFS=","} {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' >> coso;
      
done 
DDATE=$(grep -o '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' coso)
cat coso | awk -v var="$DDATE" 'BEGIN {OFS=","} {print var,$0}'| grep -v 'Linux' | grep -v ',,,,,,,,,' | grep -v 'CPU' >> cpu.$$.$(hostname).csv
rm coso*

}
# MEMORY
function memori {
for i in {$STARTDAY..$ENDDAY}; do sar -r -f /var/log/sa/sa$i 2>/dev/null | grep -v 'Average'| awk 'BEGIN {OFS=","} {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' > coso$i;DDATE=$(grep -o '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' coso$i); cat coso$i | awk -v var="$DDATE" 'BEGIN {OFS=","} {print var,$0}'| grep -v 'Linux' | grep -v ',,,,,,,,,' | grep -v 'memused'; done; rm -rf coso*; 
}

# io 
function tps {
for i in {$STARTDAY..$ENDDAY}; do sar -b -f /var/log/sa/sa$i 2>/dev/null | grep -v 'Average'| awk 'BEGIN {OFS=","} {print $1,$2,$3,$4,$5,$6,$7}' > coso$i;DDATE=$(grep -o '[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]' coso$i); cat coso$i | awk -v var="$DDATE" 'BEGIN {OFS=","} {print var,$0}'| grep -v 'Linux' | grep -v ',,,' | grep -v 'tps'; done; rm -rf coso*; 
}


cpu

