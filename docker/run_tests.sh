#!/bin/bash

container_id=$(docker ps -aqf "name=^atomic_red_team$")

echo ""
echo "running test T1105-27 - Linux download file and run..."
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1105-27

echo ""
echo "running test T1046-2 - port scan nmap..."
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1046-2 -GetPrereqs
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1046-2

echo ""
echo "running test T1574.006-1 - shared Library Injection via /etc/ld.so.preload..."
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1574.006-1 -GetPrereqs
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1574.006-1

echo ""
echo "running test T1053.003-2 - cron: add script to all cron subfolders..."
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1053.003-2 -GetPrereqs
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1053.003-2

echo ""
echo "running test T1070.003-1 - clear Bash history (rm)..."
# ensure the file exists
docker exec -it $container_id echo ls > .bash_history
docker exec -it $container_id pwsh -c Invoke-AtomicTest T1070.003-1
