#!/bin/sh
set -x

# Espera hasta que los servicios estén disponibles
until ip_freeipa=$(getent hosts freeipa-server1 | awk '{ print $1 }'); do
    echo "Esperando a que freeipa-server1 esté disponible..."
    sleep 2
done

until ip_keycloak=$(getent hosts keycloak-server | awk '{ print $1 }'); do
    echo "Esperando a que keycloak-server esté disponible..."
    sleep 2
done
'''
until ip_openkm=$(getent hosts openkm | awk '{ print $1 }'); do
    echo "Esperando a que openkm esté disponible..."
    sleep 2
done
'''
# Muestra la IP obtenida
echo "La IP de freeipa-server1 es: $ip_freeipa"
echo "La IP de keycloak-server es: $ip_keycloak"
#echo "La IP de openkm es: $ip_openkm"

# Asegúrate de aceptar tráfico en el puerto 443
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Configura iptables con la IP obtenida
#iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination ${ip}:443
iptables -t nat -A PREROUTING -p tcp --dport 443 -m multiport --sports 8081 -j DNAT --to-destination ${ip_keycloak}:8080
#iptables -t nat -A PREROUTING -p tcp --dport 443 -m multiport --sports 8200 -j DNAT --to-destination ${ip_openkm}:8080
iptables -t nat -A PREROUTING -p tcp --dport 443 -m multiport --sports 443 -j DNAT --to-destination ${ip_freeipa}:443
iptables -t nat -A POSTROUTING -j MASQUERADE

# Mantiene el contenedor en ejecución
tail -f /dev/null
