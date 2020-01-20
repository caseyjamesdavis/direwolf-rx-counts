#!/bin/sh

# crude bash script to count the numbers of packets rx'd by direwolf
# assumes direwolf is using the daily log file option, i.e., lowercase l (-l)
# run this script using watch:
#	 watch -n 15 ./direwolf_rx_counts.sh

# to do:
# 	hourly counts are a bit useless after the log file rolls over
# 		i should consider using the single log file option in direwolf


# path to location of daily log files
direwolf_log_dir="$HOME/direwolf_rx_log"

# finds latest log file
filename=$(ls $direwolf_log_dir -t | head -n1)
echo "Data Source:"
echo $filename

# defines full path to latest log file
full_path="$direwolf_log_dir/$filename"


# determines and prints the total number of packets recieved
echo " "
echo "Total in Log:"
#wc -l ./aprs_log/$filename | cut -d ' ' -f 1
awk -F',' -vDate=`date -d'now-24 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l


# number of packets rx'd in the last 3 hours
echo " "
echo "Last 3 Hours:"
awk -F',' -vDate=`date -d'now-3 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l

# number of packets rx'd in the last hour
echo " "
echo "Last Hour:"
awk -F',' -vDate=`date -d'now-1 hour' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l

# number of packets rx'd in the last 10 minutes
echo " "
echo "Last 10 Min:"
awk -F',' -vDate=`date -d'now-10 minute' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l

# number of packets rx'd in the last minute
echo " "
echo "Last Min:"
awk -F',' -vDate=`date -d'now-1 minute' +'%Y-%m-%dT%H:%M:%SZ'` '/chan/ {next} $3 > Date {print $0}' $full_path | wc -l
