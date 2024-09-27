#!/bin/bash

echo ""
echo "try to clean up from old run, running test T1105-27 - Linux download file and run..."
kubectl exec -it atomic-red-team -- pwsh -c rm /tmp/atomic.sh > /dev/null
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1105-27

echo ""
echo "running test T1046-2 - port scan nmap..."
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1046-2 -GetPrereqs
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1046-2

echo ""
echo "running test T1574.006-1 - shared Library Injection via /etc/ld.so.preload..."
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1574.006-1 -GetPrereqs
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1574.006-1

echo ""
echo "running test T1053.003-2 - cron: add script to all cron subfolders..."
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1053.003-2 -GetPrereqs
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1053.003-2

echo ""
echo "running test T1070.003-1 - clear Bash history (rm)..."
# ensure the file exists
kubectl cp -n default .bash_history atomic-red-team:/root/
kubectl exec -it atomic-red-team -- pwsh -c Invoke-AtomicTest T1070.003-1
