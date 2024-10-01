#!/bin/bash

source ./env.sh

echo ""
echo "building the container..."
echo ""
sleep 1
docker build -t $TAG ..

if [ ! "$?" -eq "0" ]; then
  echo "docker build failed... exiting..."
  exit 1
fi

# push the image somewhere (e.g. dockerhub)
echo ""
echo "pushing the image..."
echo ""
sleep 1
docker push $TAG
