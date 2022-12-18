#!/bin/sh

printServerConfig () {
  echo "[Peer]"
  echo "PublicKey = $(cat /etc/wireguard/wg0.pub)"
  echo "AllowedIPs = $1/32"
}


apt install -y wireguard

[ -d /etc/wireguard ] || mkdir /etc/wireguard

config_location=/etc/wireguard/wg0.conf
if [ -e $config_location ]; then
  echo "File $config_location already exists!"
  printServerConfig $1
  exit 1
fi

umask 077
wg genkey > wg0.key
wg pubkey < wg0.key > wg0.pub
mv wg0.key wg0.pub /etc/wireguard

cat > $config_location <<EOF
[Interface]
PostUp = wg set %i private-key /etc/wireguard/wg0.key
ListenPort = 51000
Address = $1/24

[Peer]
PublicKey = YhTw7mrpI6X6iiCWfCwTEci7QTcPYt7m5I1uvRiP8yE=
Endpoint = direct.quangtuan.me:51000
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

printServerConfig $1
