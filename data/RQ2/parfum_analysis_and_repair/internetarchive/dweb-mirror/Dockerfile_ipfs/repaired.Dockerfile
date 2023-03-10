# Running docker interactively
#   '-v ..' maps $HOME/dweb-pv on mac to /pv inside container as a 'Persistent Volume' alternative
# docker run -it -p 127.0.0.1:5001:5001 -p 8080:8080 -p 4001:4001 -v $HOME/dweb-mirror-pv:/pv --name dwebmirroripfs mitraardron/dweb-mirror-ipfs:latest bash

#TODO try alpine
FROM ubuntu:rolling
LABEL maintainer "Mitra Ardron <mitra@mitra.biz>"

RUN apt-get -y update && apt-get golang git

### Install IPFS  #####################################################
#IPFS / Docker discussion on GIT
#https://github.com/yeasy/docker-ipfs/issues/1
#https://github.com/protocol/collab-internet-archive/issues/49
#Includes suggested DOcker line of ..
#docker run -d --name ipfs-node -v /tmp/ipfs-docker-staging:/export -v /tmp/ipfs-docker-data:/data/ipfs -p 8080:8080 -p 4001:4001 -p 127.0.0.1:5001:5001)
ENV API_PORT 5001
ENV GATEWAY_PORT 8080
ENV SWARM_PORT 4001

EXPOSE ${SWARM_PORT}
# This may introduce security risk to expose API_PORT public
EXPOSE ${API_PORT}
EXPOSE ${GATEWAY_PORT}

# #https://github.com/yeasy/docker-ipfs/issues/2 asks what this does,
# Only useful for this Dockerfile
#ENV FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric

#Added to apt-get above, will need if run as separate docker
#RUN apt-get -y update && apt-get -y install golang git

# Add go path after installing go so it can find ipfs-update when installed
ENV GOPATH=/root/go
ENV PATH=${GOPATH}/bin:${PATH}
ENV IPFS_PATH=/pv/ipfs
# Mapped to a permanent volume - this has to be the home directory for the user running IPFS (which is root) so will need a link
RUN ln -s /pv/ipfs /.ipfs

## On dweb.archive.org production not doing this, instead run docker with -v so it copies in a volume
# Create the fs-repo directory and switch to a non-privileged user.
#ENV IPFS_PATH /data/ipfs
#RUN mkdir -p $IPFS_PATH \
#  && adduser -D -h $IPFS_PATH -u 1000 -G users ipfs \
#  && chown ipfs:users $IPFS_PATH
# Expose the fs-repo as a volume.
# start_ipfs initializes an fs-repo if none is mounted.
# Important this happens after any USER directive so permission are correct.
#VOLUME $IPFS_PATH



# Install ipfs using ipfs-update
# config the api endpoint, may introduce security risk to expose API_PORT public
# config the gateway endpoint
# allow access to API from localhost
# enable URLstore so it doesnt copy the files locally
RUN go get -u -v github.com/ipfs/ipfs-update \
     && ipfs-update install latest \
     && cp /app/ipfs_container_daemon_modified.sh /usr/local/bin/start_ipfs

#TODO IPFS connection is to specific peer id in library '/dns4/dweb.me/tcp/4245/wss/ipfs/QmPNgKEjC7wkpu3aHUzKKhZmbEfiGzL5TP1L8zZoHJyXZW'
#TODO which is dweb.me
#TODO once dweb.me is running in Docker, then use `ipfs config show` to get new id and add to dweb-transports/TransportIPFS config

# Supervisorctl > start_ipfs_modified.sh > ipfs daemon --enable-gc --migrate=true