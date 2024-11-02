#!/bin/sh
set -x

# Espera hasta que freeipa-server1 esté disponible
until ip=$(getent hosts freeipa-server1 | awk '{ print $1 }'); do
    echo "Esperando a que freeipa-server1 esté disponible..."
    sleep 2
done

# Muestra la IP obtenida
echo "La IP de freeipa-server1 es: $ip"

# Asegúrate de aceptar tráfico en el puerto 443
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Configura iptables con la IP obtenida
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination ${ip}:443
iptables -t nat -A POSTROUTING -j MASQUERADE

# Mantiene el contenedor en ejecución
tail -f /dev/null
