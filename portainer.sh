#!/bin/bash

# Create the Portainer data volume
docker volume create portainer_data

# Start the Portainer container
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Create a docker-compose.yml file for MariaDB and Nginx Proxy Manager
cat <<EOL > docker-compose.yml
version: "2"
services:
  db:
    image: yobasystems/alpine-mariadb:latest
    container_name: db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 'root-pass'
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: 'npm'
      MYSQL_PASSWORD: 'npm-pass'
    volumes:
      - /BigThiccums/ContainerConfigs/MariaDB/data/mysql:/var/lib/mysql
  npm:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: npm
    restart: always
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm-pass"
      DB_MYSQL_NAME: "npm"
      DISABLE_IPV6: 'true'
    volumes:
      - /BigThiccums/ContainerConfigs/NPM/data:/data
      - /BigThiccums/ContainerConfigs/NPM/letsencrypt:/etc/letsencrypt
    depends_on:
      - db
EOL

# Start the MariaDB and Nginx Proxy Manager containers using Docker Compose
docker-compose up -d
