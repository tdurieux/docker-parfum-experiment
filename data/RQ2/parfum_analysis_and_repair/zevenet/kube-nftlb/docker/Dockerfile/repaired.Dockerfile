#################################################
# Temporal container: compile kube-nftlb-client #
#################################################
FROM golang:1.15.2-buster AS client-builder

# Default shell when executing RUN
SHELL ["/bin/bash", "-c"]

# Read issue and accepted answer: https://github.com/moby/moby/issues/34513#issuecomment-389467566
LABEL stage=intermediate

# Start at /kube-nftlb dir
WORKDIR /kube-nftlb

# Copy everything to /kube-nftlb
COPY . .

# Compile kube-nftlb-client using local dependencies
RUN GOOS=linux CGO_ENABLED=1 go build -tags 'osusergo netgo' -mod=vendor ./cmd/kube-nftlb-client


###############################################
# Main container: nftlb and kube-nftlb-client #
###############################################
FROM debian:buster-slim

# Default shell when executing RUN
SHELL ["/bin/bash", "-c"]

# Needed to copy files from DOCKER_PATH dir
ARG DOCKER_PATH

# Start at root dir
WORKDIR /

# Put Debian in not interactive mode
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install essential tools
RUN apt-get update
RUN apt-get install --no-install-recommends -y gnupg ca-certificates wget procps && rm -rf /var/lib/apt/lists/*;

# Install nftables and dependencies
RUN wget -O - https://repo.zevenet.com/zevenet.com.gpg.key | apt-key add -
RUN echo "deb [arch=amd64] http://repo.zevenet.com/ce/v5 buster main" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y libev4 libjansson4 libnftnl11 nftables && rm -rf /var/lib/apt/lists/*;

# Add external files and compiled kube-nftlb-client to this container
COPY ${DOCKER_PATH}/start.sh .
COPY ${DOCKER_PATH}/nftlb.deb .
COPY .env .
COPY --from=client-builder /kube-nftlb/kube-nftlb-client ./goclient

# Replace nftlb with a devel version if nftlb.deb exists in this directory
RUN if [ -s "nftlb.deb" ] ;then dpkg -i ./nftlb.deb ; rm -f ./nftlb.deb ;else apt-get install --no-install-recommends -y nftlb; rm -rf /var/lib/apt/lists/*; fi

CMD [ "/bin/bash", "-c", "/start.sh" ]
