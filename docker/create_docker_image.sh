#!/bin/bash

source ./env.sh

echo ""
echo "building the container..."
echo ""
sleep 1
docker build -t $TAG .. &&

# push the image somewhere (e.g. dockerhub)
echo ""
echo "pushing the image..."
echo ""
sleep 1
docker push $TAG
