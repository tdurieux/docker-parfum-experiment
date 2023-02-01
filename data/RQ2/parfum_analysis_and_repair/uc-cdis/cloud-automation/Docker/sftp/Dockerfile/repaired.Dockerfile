FROM atmoz/sftp:debian-jessie
RUN apt-get update && apt-get install --no-install-recommends -y mcrypt=2.6.8-1.3 && rm -rf /var/lib/apt/lists/*;
