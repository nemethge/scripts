#!/bin/bash

# Script Verzió: 1.2

# Frissítse a csomaglistákat és telepítse a szükséges csomagokat
sudo apt update
sudo apt install -y snapd git

# Adja hozzá a snap bináris útvonalát a PATH-hoz
export PATH=$PATH:/snap/bin

# Lépjen a home könyvtárba és hozzon létre könyvtárakat az etcd pillanatképekhez és biztonsági mentésekhez
cd && mkdir -p etcd-snapshots etcd-backups

# Telepítse a k3s-t
curl -sfL https://get.k3s.io | sh -s server - --cluster-init --token "1234" --write-kubeconfig-mode 644 --disable traefik --data-dir=/home/$(whoami)/etcd-backups --etcd-snapshot-retention=72 --etcd-snapshot-dir=/home/$(whoami)/etcd-snapshots --etcd-snapshot-schedule-cron="*/3 * * * *"

# Hozzon létre egy alias-t a kubectl számára
echo "alias k=kubectl" >> ~/.bashrc
source ~/.bashrc

# Telepítse a Helm-et
sudo snap install helm --classic
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# (Opcionális) Ha szeretné módosítani az alapértelmezett szerkesztőt, állítsa be a KUBE_EDITOR környezeti változót
export KUBE_EDITOR="nano"

# Klónozza a k3s-monitoring repository-t és lépjen be a könyvtárba
git clone https://github.com/cablespaghetti/k3s-monitoring.git
cd k3s-monitoring

# Adja hozzá a Prometheus Helm chart tárhelyét és frissítse
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Telepítse a Prometheust és a Grafanát
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --version 39.13.3 --values kube-prometheus-stack-values.yaml

# Emlékeztető a Grafana szolgáltatás manuális módosítására
echo "Ne felejtse el manuálisan módosítani a Grafana szolgáltatást a 'kubectl edit service/prometheus-grafana' parancs használatával, és állítsa be a típust NodePort-ra."
