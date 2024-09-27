#!/bin/bash

container_name="atomic_red_team"
container_id=$(docker ps -aqf "name=^$container_name$")
docker stop $container_id; docker rm $container_id

container_name="dd-agent"
container_id=$(docker ps -aqf "name=^$container_name$")
docker stop $container_id; docker rm $container_id
