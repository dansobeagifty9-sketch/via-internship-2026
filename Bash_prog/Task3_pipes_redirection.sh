
#!/bin/bash
#!/usr/bin/env bash
# @title        Task1_file_handling.sh
# @author       <Asamoah Gifty Dansobea>
# @index        <4184424>
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  <this script is used to manipulate where input comes from and where command output goes>
# @date         <September 16 2026>
# 1. Generate sample log data

cat > sample_logs.txt << EOF
2026-09-11 10:03:21 INFO 192.168.1.10 User login successful
2026-09-11 10:03:45 ERROR 192.168.1.23 Connection timeout
2026-09-11 10:04:02 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:04:15 INFO 192.168.1.15 File uploaded successfully
2026-09-11 10:04:30 INFO 192.168.1.20 User login successful
2026-09-11 10:05:01 ERROR 192.168.1.23 Database connection failed
2026-09-11 10:05:17 WARN 192.168.1.18 High memory usage
2026-09-11 10:05:32 INFO 192.168.1.10 User logout successful
2026-09-11 10:05:48 INFO 192.168.1.15 File downloaded successfully
2026-09-11 10:06:03 ERROR 192.168.1.30 Authentication failed
2026-09-11 10:06:19 WARN 192.168.1.20 CPU usage above 80%
2026-09-11 10:06:35 INFO 192.168.1.10 User login successful
2026-09-11 10:06:51 ERROR 192.168.1.23 Connection refused
2026-09-11 10:07:07 INFO 192.168.1.15 File uploaded successfully
2026-09-11 10:07:23 WARN 192.168.1.18 Disk usage above 80%
2026-09-11 10:07:39 INFO 192.168.1.20 User login successful
2026-09-11 10:07:55 ERROR 192.168.1.30 Invalid password
2026-09-11 10:08:11 INFO 192.168.1.10 User logout successful
2026-09-11 10:08:27 WARN 192.168.1.15 High memory usage
2026-09-11 10:08:43 INFO 192.168.1.23 User login successful
2026-09-11 10:08:59 ERROR 192.168.1.20 Request timeout
2026-09-11 10:09:15 INFO 192.168.1.10 File uploaded successfully
2026-09-11 10:09:31 WARN 192.168.1.18 CPU usage above 80%
2026-09-11 10:09:47 ERROR 192.168.1.23 Database connection failed
2026-09-11 10:10:03 INFO 192.168.1.15 User login successful
2026-09-11 10:10:19 INFO 192.168.1.20 User logout successful
2026-09-11 10:10:35 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:10:51 ERROR 192.168.1.30 Connection timeout
2026-09-11 10:11:07 INFO 192.168.1.23 File downloaded successfully
2026-09-11 10:11:23 WARN 192.168.1.15 High memory usage
2026-09-11 10:11:39 INFO 192.168.1.10 User login successful
2026-09-11 10:11:55 ERROR 192.168.1.20 Authentication failed
2026-09-11 10:12:11 INFO 192.168.1.18 File uploaded successfully
2026-09-11 10:12:27 WARN 192.168.1.23 CPU usage above 80%
2026-09-11 10:12:43 ERROR 192.168.1.30 Invalid password
2026-09-11 10:12:59 INFO 192.168.1.15 User login successful
2026-09-11 10:13:15 INFO 192.168.1.20 File downloaded successfully
2026-09-11 10:13:31 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:13:47 ERROR 192.168.1.23 Request timeout
2026-09-11 10:14:03 INFO 192.168.1.18 User logout successful
2026-09-11 10:14:19 WARN 192.168.1.15 High memory usage
2026-09-11 10:14:35 INFO 192.168.1.10 File uploaded successfully
2026-09-11 10:14:51 ERROR 192.168.1.20 Database connection failed
2026-09-11 10:15:07 INFO 192.168.1.23 User login successful
2026-09-11 10:15:23 WARN 192.168.1.30 CPU usage above 80%
2026-09-11 10:15:39 ERROR 192.168.1.18 Connection refused
2026-09-11 10:15:55 INFO 192.168.1.15 User logout successful
2026-09-11 10:16:11 WARN 192.168.1.20 Disk usage above 80%
2026-09-11 10:16:27 INFO 192.168.1.10 User login successful
2026-09-11 10:16:43 ERROR 192.168.1.23 Authentication failed
2026-09-11 10:16:59 INFO 192.168.1.18 File downloaded successfully
2026-09-11 10:17:15 WARN 192.168.1.15 CPU usage above 80%
EOF


# 2. Create the results file and error log


> results.txt
> errors.log


# 3. Total number of log lines

echo "===== LOG SUMMARY =====" >> results.txt

echo "Total number of log lines:" >> results.txt
wc -l < sample_logs.txt >> results.txt


# 4. Count lines for each log level


echo "" >> results.txt
echo "Log level counts:" >> results.txt

awk '{print $3}' sample_logs.txt 2> errors.log | sort | uniq -c >> results.txt


# 5. Find the top 3 most frequent IP addresses

echo "" >> results.txt
echo "Top 3 most frequent IP addresses:" >> results.txt

awk '{print $4}' sample_logs.txt 2> 
errors.log | sort | uniq -c | sort -nr | head -3 >> results.txt



# 6. Display all ERROR lines

echo "" >> results.txt
echo "ERROR lines:" >> results.txt

grep " ERROR " sample_logs.txt 2> errors.log >> results.txt


7. Display a message on the terminal

echo "Task 3 completed successfully."
echo "Results have been saved to results.txt"
echo "Any command errors have been saved to errors.log"
```
