FROM mono:latest
RUN /bin/sed -i 's/^mozilla\/DST_Root_CA_X3.crt$/!mozilla\/DST_Root_CA_X3.crt/' /etc/ca-certificates.conf && \
    /usr/sbin/update-ca-certificates
RUN useradd -ms /bin/bash netkan
USER netkan
WORKDIR /home/netkan
ADD netkan.exe .
ENTRYPOINT /usr/bin/mono netkan.exe --queues $QUEUES \
  --net-useragent 'Mozilla/5.0 (compatible; Netkanbot/1.0; CKAN; +https://github.com/KSP-CKAN/NetKAN-Infra)' \
  --github-token $GH_Token --cachedir ckan_cache -v