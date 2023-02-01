FROM ghcr.io/savoirfairelinux/opendht/opendht:latest
CMD ["dhtnode", "-b", "bootstrap.jami.net", "-p", "4222", "--proxyserver", "8080"]
EXPOSE 4222/udp
EXPOSE 8080/tcp