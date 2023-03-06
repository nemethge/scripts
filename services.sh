#!/bin/bash

# Get the hostname and IP address
hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed"
fi

# Find all Docker Compose files in the current directory and its subdirectories
compose_files=$(find . -name docker-compose.yml)

# Check if any Docker Compose files were found
if [ -z "$compose_files" ]
then
    echo "No Docker Compose files found"
    exit 1
fi

# Generate HTML output for Docker Compose services
docker_compose_html="<h1>Docker Compose Services on $hostname ($ip_address)</h1>\n<table>\n<tr><th>Service</th><th>Status</th><th>Compose File</th></tr>\n"

for file in $compose_files
do
    # Get the status of each service in the Docker Compose file
    services_status=$(docker-compose -f "$file" ps --services | while read service; do
        if docker-compose -f "$file" ps "$service" | grep -q "Up"; then
            echo "$service: Running"
        else
            echo "$service: Not Running"
        fi
    done)

    # Add the service status and Docker Compose file information to the HTML output
    docker_compose_html+="<tr><td>$services_status</td><td>$file</td></tr>\n"
done

# Complete the HTML output for Docker Compose services
docker_compose_html+="</table>\n"

# Generate HTML output for system services
system_services_html="<h1>System Services Status on $hostname ($ip_address)</h1>\n<table>\n<tr><th>Service</th><th>Status</th></tr>\n"

# Get the list of all system services
services=$(systemctl list-units --type=service --state=active --no-pager --no-legend | awk '{print $1}')

# Check if any services were found
if [ -z "$services" ]
then
    echo "No system services found"
    exit 1
fi

# Loop through each service and get its status
for service in $services
do
    status=$(systemctl is-active "$service")
    # Add the service status and name to the HTML output
    system_services_html+="<tr><td>$service</td><td>$status</td></tr>\n"
done

# Complete the HTML output for system services
system_services_html+="</table>\n"

# Combine the HTML output for Docker Compose services and system services
html_output="<html>\n<head>\n<title>Services Status</title>\n</head>\n<body>\n$docker_compose_html\n$system_services_html</body>\n</html>"

# Write the combined HTML output to a file
echo -e "$html_output" > services-status.html

echo "Services status HTML page generated"
