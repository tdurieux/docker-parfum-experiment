FROM nextcloud:apache

RUN apt-get update && apt-get install --no-install-recommends -y procps smbclient && rm -rf /var/lib/apt/lists/*
