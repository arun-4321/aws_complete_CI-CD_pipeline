#!/bin/bash
set -e

container_ids=$(docker ps -q)

if [ -n "$container_ids" ]; then
  echo "Stopping and removing all running containers..."
  docker stop $container_ids
  docker rm $container_ids
else
  echo "No running containers to stop."
fi
