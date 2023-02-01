FROM ubuntu:18.04

# update && java 11 install
RUN apt-get update && \
apt-get upgrade -y && \
 apt-get install --no-install-recommends -y software-properties-common && \
add-apt-repository ppa:linuxuprising/java -y && \
apt-get update && \
echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections && \
 apt-get install --no-install-recommends -y oracle-java11-installer && \
 apt-get install -y --no-install-recommends oracle-java11-set-default && \
apt-get clean && rm -rf /var/lib/apt/lists/*;
# setup worker dir
WORKDIR /credits
# copy all files from current dir to ./credits
COPY /build /credits
# ports
EXPOSE 6000
EXPOSE 9090
# run
CMD ["./runner", "--db-path main_db/ --public-key-file main_keys/public.txt --private-key-file main_keys/private.txt"]
