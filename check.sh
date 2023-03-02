#!/bin/bash

# List running services
echo "Running services:"
systemctl list-units --type=service --state=running

# List running containers
echo "Running containers:"
docker ps

# List compose files
echo "Compose files:"
find / -name docker-compose.yml -type f
