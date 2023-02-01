FROM debian:stretch

# Installation de NGINX et dnsmasq
RUN apt-get update && apt-get install --no-install-recommends nginx curl dnsmasq -y && rm -rf /var/lib/apt/lists/*;

# Création du dossier contenant les certificats
RUN mkdir /etc/nginx/certificates

# Volumes
VOLUME /etc/nginx/sites-enabled
VOLUME /etc/nginx/certificates

# Copie des fichiers de configuration
COPY confs/nginx.conf /etc/nginx/
COPY confs/proxy.conf /etc/nginx/conf.d/

# Exposition du port
EXPOSE 80 443

# Add command
CMD ["nginx", "-g", "daemon off;"]
HEALTHCHECK CMD curl --fail http://localhost || exit 1
