# Először távolítsuk el a K3s-t
/usr/local/bin/k3s-uninstall.sh

# Várjunk néhány másodpercet a törlés befejezéséhez
sleep 5

# Telepítsük újra a K3s-t
curl -sfL https://get.k3s.io | sh -

# Várjunk néhány másodpercet, hogy a szolgáltatás elinduljon
sleep 5

# Ellenőrizzük, hogy a csomópont elindult-e
kubectl get nodes

# Ellenőrizzük, hogy a rendszer podok futnak-e
kubectl get pods -A
