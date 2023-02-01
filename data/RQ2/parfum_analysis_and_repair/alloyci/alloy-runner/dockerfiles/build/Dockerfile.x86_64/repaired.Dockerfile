FROM alpine:3.4

RUN apk add --no-cache bash ca-certificates git miniperl \ 
	&& ln -s miniperl /usr/bin/perl

RUN cd /tmp && \
	apk add --no-cache -U openssl && \
	wget https://github.com/git-lfs/git-lfs/releases/download/v2.3.1/git-lfs-linux-amd64-2.3.1.tar.gz && \
	tar zxf git-lfs-linux-amd64-2.3.1.tar.gz && \
	mv git-lfs-*/git-lfs /usr/bin/ && \
	git lfs install && \
	apk del --purge openssl && \
	rm -rf /tmp/* && rm git-lfs-linux-amd64-2.3.1.tar.gz

COPY ./ /usr/bin

