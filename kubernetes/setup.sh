#!/bin/bash

# load env vars
source ./env.sh

# start red team
kubectl run atomic-red-team --image $TAG --privileged=true

# create ns for Datadog agent
kubectl create ns datadog

# create secret for agent
kubectl create secret generic datadog-secret --from-literal api-key=$DD_API_KEY -n datadog

# install agent
helm repo add datadog https://helm.datadoghq.com
helm install dd-operator datadog/datadog-operator -n datadog
kubectl apply -f dd-agent.yaml -n datadog

# watch pods come up
kubectl get po -n datadog -w
