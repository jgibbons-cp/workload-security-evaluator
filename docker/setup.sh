#!/bin/bash

docker ps > /dev/null
if [ ! "$?" -eq "0" ]; then
  echo "docker is either not running or can't run as a non-root user... exiting..."
  exit 1
fi

container_name="atomic_red_team"
container_id=$(docker ps -aqf "name=^$container_name$")

if [ -n "$container_id" ]; then
  echo "atomic_red_team container already running with ID $container_id... exiting..."
  exit 1
fi 

echo "setting env vars..."
echo ""
source ./env.sh 

if [ "$?" -ne "0" ]; then
  echo "ERROR: probably using sh rather than bash to execute the program. Exiting..."
  exit 1
fi 

echo ""
echo "running the container..."
echo ""
sleep 1
docker run --name atomic_red_team --privileged -d $TAG

echo ""
echo "getting container_id..."
echo ""
sleep 1

while [ -z "$container_id" ]
do
  container_id=$(docker ps -aqf "name=^atomic_red_team$")
done

echo ""
echo "starting Datadog agent..."
echo ""
docker run -d --name dd-agent \
  --cgroupns host \
  --pid host \
  --security-opt apparmor:unconfined \
  --cap-add SYS_ADMIN \
  --cap-add SYS_RESOURCE \
  --cap-add SYS_PTRACE \
  --cap-add NET_ADMIN \
  --cap-add NET_BROADCAST \
  --cap-add NET_RAW \
  --cap-add IPC_LOCK \
  --cap-add CHOWN \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -v /etc/passwd:/etc/passwd:ro \
  -v /etc/group:/etc/group:ro \
  -v /:/host/root:ro \
  -v /sys/kernel/debug:/sys/kernel/debug \
  -v /etc/os-release:/etc/os-release \
  -e DD_RUNTIME_SECURITY_CONFIG_ENABLED=true \
  -e DD_RUNTIME_SECURITY_CONFIG_REMOTE_CONFIGURATION_ENABLED=true \
  -e HOST_ROOT=/host/root \
  -e DD_API_KEY=$DD_API_KEY \
  gcr.io/datadoghq/agent:7

echo ""
echo "setup complete, let's shell into the atomic red team container so we can use it..."
echo ""
docker exec -it $container_id pwsh

