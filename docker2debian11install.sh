Just install Docker
$ curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

Install Docker and Rancher Server
$ curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh && sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server
