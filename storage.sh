#!/bin/bash

###################### for date variable function #############################

date=$(date --utc --rfc-3339=seconds | sed 's/\s/T/g')

host=$(hostname)

log_file='/opt/splunk/var/log/splunk/linux_storage.log'

partition_list=$(  df | grep -v "Mounted" | awk '{print $1$6"_"}' )

###############################################################################

colect_data_func()
{
total_size=$( df | grep -v "Mounted" | awk '{print $1$6"_",$0}' | grep $i | awk '{print $3}' )

used_size=$( df | grep -v "Mounted" | awk '{print $1$6"_",$0}' | grep $i | awk '{print $4}' )

avl_size=$( df | grep -v "Mounted" | awk '{print $1$6"_",$0}' | grep $i | awk '{print $5}' )

per_used=$( df | grep -v "Mounted" | awk '{print $1$6"_",$0}' | grep $i | awk '{print $6}' )

storage_name=$( df | grep -v "Mounted" | awk '{print $1$6"_",$0}' | grep $i | awk '{print $7}' )

echo $date $host "total_size="$total_size "used_size="$used_size "avl_size="$avl_size "per_used="$per_used "storage_name="$storage_name >> $log_file

}

### Checking server is linux OS ###

man_check=$( man --version | wc -l )

if [[ "$man_check" == "1" ]];
   then
   echo $date $host "mesg=Host is linux server" > $log_file
   echo $partition_list > list.txt

   else
      echo $date $host "mesg=Host is not linux server" > $log_file

fi

for i in $(cat list.txt)
do
   echo $i
   colect_data_func
done

echo $date $host "mesg=Loop completed" >> $log_file
