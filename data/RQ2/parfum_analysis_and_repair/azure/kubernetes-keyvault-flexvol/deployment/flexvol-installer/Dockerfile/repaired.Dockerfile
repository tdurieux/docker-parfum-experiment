FROM alpine:3.11

WORKDIR /bin

RUN apk add --no-cache bash
ADD ./kv /bin/kv
ADD ./azurekeyvault-flexvolume /bin/azurekeyvault-flexvolume
RUN chmod a+x /bin/kv
RUN chmod a+x /bin/azurekeyvault-flexvolume
ADD ./install.sh /bin/install_kv_flexvol.sh


ENTRYPOINT ["/bin/install_kv_flexvol.sh"] 