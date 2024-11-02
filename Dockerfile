# Dockerfile
FROM freeipa/freeipa-server:rocky-8-4.9.11

# Exponer los puertos necesarios
# LDAP
EXPOSE 389      
# LDAPS
EXPOSE 636      
# Kerberos UDP
EXPOSE 88       
# Kerberos TCP
EXPOSE 88       
# Kerberos change password UDP
EXPOSE 464      
# Kerberos change password TCP
EXPOSE 464      
# HTTP
EXPOSE 80       
# HTTPS
EXPOSE 443      