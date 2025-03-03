#!/bin/bash

# load env vars
source ./env.sh

# start red team
kubectl run atomic-red-team --image $TAG --privileged=true

# create ns for Datadog agent
kubectl create ns datadog

# create secret for operator/agent
kubectl create secret generic datadog-secret --from-literal api-key=$DD_API_KEY -n datadog

# install operator
helm repo add datadog https://helm.datadoghq.com
helm install dd-operator datadog/datadog-operator -n datadog

# make sure operator is running
ret_val=1
while [ "$ret_val" -ne "0" ]
do
  kubectl get po -n datadog | grep dd-operator-datadog | grep Running
  ret_val=$?
done

# create agent
kubectl apply -f dd-agent.yaml -n datadog

# let it start up
ret_val=1
while [ "$ret_val" -ne "0" ]
do
  kubectl get po -n datadog | grep datadog-agent | grep Running
  ret_val=$?
done

# grab name
pod_name=$(kubectl get po -n datadog  | grep datadog-agent | awk '{print $1;}')

# make sure system-probe is running
ret_val=1
while [ "$ret_val" -ne "0" ]
do
  kubectl get po -n datadog | grep datadog-agent | grep Crash
  ret_val=$?
  if [ "$ret_val" -ne "1" ]; then
    echo "Exiting... agent in CrashLoopBackoff...\n"
  fi

  kubectl exec -n datadog $pod_name -- grep "tracing started" /var/log/datadog/system-probe.log 2>/dev/null
  ret_val=$?
done

# make sure cluster agent is running
ret_val=1
while [ "$ret_val" -ne "1" ]
do
  kubectl get po -n datadog | grep cluster-agent | grep Running
  ret_val=$?
done

# ensure all containers are ready
ret_val=0
while [ "$ret_val" -ne "1" ]
do
  kubectl get po -n datadog | grep -E '(0/1|1/4|2/4|3/4)'
  ret_val=$?
done

# all pods are up
kubectl get po -n datadog
