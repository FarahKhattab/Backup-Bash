#!/bin/bash
# define src and dest

src_dir=$1
dest_dir=$2
sec=$3
max_backup=$4

# inf loop

while true
do
	ls -Rl $src_dir > current_status.txt
	changed=$(diff current_status.txt last_status.txt | wc -l)
	echo $changed
	
	if [ $changed = 0 ]
 	then
	 	echo "not changed"
	 else
		 echo "changed"
		 file_count=$(ls -1 $dest_dir | wc -l)
		 echo $file_count
		 if [ $file_count -lt $max_backup ]
	 	 then
		 new_dir=$(date +'%Y-%m-%d-%I-%M-%S')
		 mkdir $dest_dir/$new_dir
		 cp -r $src_dir $dest_dir/$new_dir
		 else
		 echo "reach file count limit"
		 oldest_backup=$(ls -1t $dest_dir | tail -1)
		 echo $oldest_backup 
		 rm -r $dest_dir/$oldest_backup
		 new_dir=$(date +'%Y-%m-%d-%I-%M-%S')
		 mkdir $dest_dir/$new_dir
		 cp -r $src_dir $dest_dir/$new_dir
		 fi
		 cat current_status.txt > last_status.txt
	 fi
	 sleep $sec
 done
