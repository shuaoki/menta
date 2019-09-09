#!/bin/sh

BK_DATE=`date +'%Y%m%d'`
BK_NAME=/home/vagrant/backup

mysqldump --single-transaction -u root -pAokipiza0027# menta > $BK_NAME/menta_$BK_DATE.dump

aws s3 cp $BK_NAME/menta_$BK_DATE.dump s3://menta-20190909/

aws s3 ls s3://menta-20190909 > list.log
num=`cat list.log |awk 'END {print NR}'`
num=`expr $num - 7`
echo "delete num = $num"
echo "delete list"
cat list.log |head -n $num

for target in `seq 1 $num`
	do
  rmfile=`cat list.log |awk '{print $4}' | head -n $target`
	done
	
echo $rmfile
  
for delete in $rmfile
	do
  aws s3 rm s3://menta-20190909/$delete
	done
