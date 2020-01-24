#!/bin/sh

# crude bash script to count the number of packets rx'd by direwolf
# assumes direwolf is using the daily log file option, i.e., lowercase l (-l)

while :
do
	clear

	# path to location of daily log files
	direwolf_log_dir="$HOME/direwolf_rx_log"

	# finds two most recent log files in directory
	second_newest_file=$(ls $direwolf_log_dir -Art | tail -n 2 | head -n 1)
	first_newest_file=$(ls $direwolf_log_dir -Art | tail -n 2 | tail -n 1)

	echo "Data Sources:"
	echo $second_newest_file
	echo $first_newest_file
	echo ""

	# define list of times for awk command and labels for output
	dt=("now-24 hour" "now-3 hour" "now-1 hour" "now-10 minute" "now-1 minute")
	label=("Last 24 Hrs:" "Last 3 Hrs:" "Last 1 Hr:" "Last 10 Mins:" "Last Min:")

	# loop to run awk command for each time defined above
	for i in ${!dt[@]};
	do

		t_setting=${dt[$i]}
		description=${label[$i]}

		echo $description

		cat $direwolf_log_dir/$second_newest_file $direwolf_log_dir/$first_newest_file | awk -F',' -vDate=`date -d "$t_setting" +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' | wc -l

		echo ""

	done

	# get names of 'source' from logs, i.e., stations which were heard directly
	echo ""
        echo "Rx Sources in the Last 3 Hrs:"
	echo ""
	
	cat $direwolf_log_dir/$second_newest_file $direwolf_log_dir/$first_newest_file | awk -F',' -vDate=`date -d 'now-3 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $5}' | sort | uniq -c | sort -r

	# pause infinite loop
	sleep 10s

done
