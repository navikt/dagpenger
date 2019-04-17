#!/usr/bin/env bash

DOCKER_PROCESSES=$(docker ps -a -q)




# Stop and delete all containers and their associated volumes.
if [[ -n "$DOCKER_PROCESSES" ]]; then
    printf "Docker Processes: \n%s\n\n" "$DOCKER_PROCESSES"

    docker stop $DOCKER_PROCESSES
    printf "Stopped all running Docker containers.\n"

    docker rm --volumes $DOCKER_PROCESSES
    printf "Deleted all Docker containers and their associated volumes.\n"
else
    printf "There were no Docker containers to delete.\n"
fi


if [[ -d ./docker_tmp ]]; then
    printf "Removing  docker_tmp folder"
    rm -rf ./docker_tmp
else
    printf "There were no docker_tmp to delete.\n"
fi
