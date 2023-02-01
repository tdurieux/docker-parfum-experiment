## Builder image
FROM bailongma:latest as builder
FROM tdengine/tdengine:latest 


WORKDIR /root/

# COPY --from=builder /root/build/build/lib/libtaos.so /usr/lib/libtaos.so.1
# RUN ln -s /usr/lib/libtaos.so.1 /usr/lib/libtaos.so

COPY --from=builder /root/blm_telegraf /root/

#COPY community/packaging/cfg/taos.cfg /etc/taos/