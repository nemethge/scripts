sudo docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
docker logs  container-id  2>&1 | grep "Bootstrap Password:"
