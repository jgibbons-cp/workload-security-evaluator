#!/bin/bash

# rm pod
kubectl delete po atomic-red-team

# rm Datadog agent
kubectl delete -f dd-agent.yaml -n datadog

# rm Datadog operator
helm uninstall dd-operator -n datadog

# rm Datadog secret
kubectl delete secret datadog-secret -n datadog

# rm datadog ns
kubectl delete ns datadog
