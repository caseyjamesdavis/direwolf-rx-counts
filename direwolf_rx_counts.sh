#!/bin/sh

# crude bash script to count the number of packets rx'd by direwolf
# assumes direwolf is using the daily log file option, i.e., lowercase l (-l)
# Casey J. Davis 2020.02.13

# forever loop
while :
do
	clear

	# location of daily log files
	direwolf_log_dir="$HOME/direwolf_rx_log"

	# finds two most recent log files
	second_newest_file=$(ls $direwolf_log_dir | sort -m | tail -n 2 | head -n 1)
	first_newest_file=$(ls $direwolf_log_dir | sort -m | tail -n 2 | tail -n 1)

	printf "%-15s %-15s\n" "Data Sources:" $second_newest_file
	printf "%-15s %-15s\n\n" "" $first_newest_file 
	
	# define complete paths to both log files
	two_files="$direwolf_log_dir/$second_newest_file $direwolf_log_dir/$first_newest_file"

	# define list of times for awk command and labels for output
#	dt=("now-24 hour" "now-3 hour" "now-1 hour" "now-10 minute" "now-1 minute")
#	label=("Last 24 Hrs:" "Last 3 Hrs:" "Last 1 Hr:" "Last 10 Min:" "Last Min:")

	dt=("now-24 hour" "now-1000 minute" "now-100 minute" "now-10 minute" "now-1 minute")
	label=("24 Hrs:" "1000 Min:" "100 Min:" "10 Min:" "1 Min:")


	printf "%-25s\n\n" "Rx packet counts in the last:"	



	# loop to run awk command for each time defined above and for both log files
	for i in ${!dt[@]};
	do

		count=$(awk -F',' -vDate=`date -d "${dt[$i]}" +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $two_files | wc -l)

		printf "%12s %-6i\n\n" "${label[$i]}" $count

	done

	# get names of 'source' from logs, i.e., stations which were heard directly

	rx_sources=$(awk -F',' -vDate=`date -d 'now-100 min' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $5}' $two_files | sort | uniq -c | sort -r)
#	rx_sources=$(awk -F',' -vDate=`date -d 'now-3 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $5 "\t" $11 "\t" $12}' $two_files | sort -n -s -k1,1)




	printf "%-25s\n\n" "Rx sources in the last 100 minutes:"

	printf "%s\n\n" "$rx_sources"



#	awk -F ',' '$5 == "W1UWS-1" {print $5 "\t" $11 "\t" $12}' $two_files
#	awk -F ',' '/W1UWS-1/ {print $0}' $two_files



	# pause infinite loop
	sleep 10s

done
