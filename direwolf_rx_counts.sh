#!/bin/sh

# crude bash script to count the number of packets rx'd by direwolf
# assumes direwolf is using the daily log file option, i.e., lowercase l (-l)

while :
do
	clear

	# path to location of daily log files
	direwolf_log_dir="$HOME/direwolf_rx_log"

	# finds latest log file
	filename=$(ls $direwolf_log_dir -t | head -n1)
	echo "Data Source:"
	echo $filename
	echo ""

	# defines full path to latest log file
	full_path="$direwolf_log_dir/$filename"

	dt=("now-24 hour" "now-3 hour" "now-1 hour" "now-10 minute" "now-1 minute")
	label=("Total in Log:" "Last 3 Hrs:" "Last 1 Hr:" "Last 10 Mins:" "Last Min:")

	for i in ${!dt[@]};
	do

		t_setting=${dt[$i]}
		description=${label[$i]}

		echo $description

		awk -F',' -vDate=`date -d "$t_setting" +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l

		echo ""

	done


	echo ""
        echo "Rx Sources in the Last 3 Hrs:"
	echo ""
	
	awk -F',' -vDate=`date -d 'now-3 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $5}' $full_path | sort | uniq -c | sort -r


	sleep 10s

done
