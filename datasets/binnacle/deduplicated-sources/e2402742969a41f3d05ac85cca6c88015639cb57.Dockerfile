FROM golang:1.8-alpine
MAINTAINER Gerry Gleason && Christopher Reay

RUN apk add --update \
      ca-certificates \
      curl wget \
      curl-dev \
      procps \
      openrc \
      git \
      make \
      sudo \
      su-exec \
    && rm -rf /var/cache/apk/* \
    \
    && chmod +s /usr/bin/passwd
RUN addgroup holochain -g 868 \
    && adduser -G holochain -u 868 -D holochain \
    && sed -i~orig -e'/wheel/s/$/,holochain/' /etc/group \
    && passwd -u holochain \
    && sed -i~orig -e'/ALL) ALL/s/# %wheel/%wheel/' /etc/sudoers \
    && mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

# Install gx and holochain and all their dependencies and hold them in a docker image
## Using Docker env tools, because we are installing everything as root
  ENV GOPATH=/work/golang \
      GOBIN=/home/holochain/bin
  ENV PATH=$GOPATH/bin:/usr/local/go/bin:$GOBIN:$PATH

  RUN go get -v -u github.com/whyrusleeping/gx
  RUN go get -v -d github.com/holochain/holochain-proto

  WORKDIR /work/golang/src/github.com/holochain/holochain-proto
  RUN make deps

WORKDIR /work/golang/src/github.com/holochain/holochain-proto

# make our development files available to hc, on top of the cached image "so far" from above
  ADD . /work/holochain

  # this rm line works well because it stops weird artifacts coming over from github.com/holochain/holochain-proto::master
  RUN rm -rf /work/golang/src/github.com/holochain/holochain-proto/* \
      && cp -pr /work/holochain/* /work/golang/src/github.com/holochain/holochain-proto/ \
      && chown -R root:holochain /work \
      && chmod 775 -R /work

# compile and test our development files
  RUN make; make bs
  RUN make test

EXPOSE 3141

# sort out dynamic user login
  COPY        scriptsAccessibleByDockerfiles/entrypoint.sh.addHostUserToContainer /usr/local/bin/entrypoint.sh.addHostUserToContainer
  RUN         chmod +x /usr/local/bin/entrypoint.sh.addHostUserToContainer
  ENTRYPOINT  ["/usr/local/bin/entrypoint.sh.addHostUserToContainer"]


#CMD ["su", "holochain", "-c", "source /etc/holochain.env_vars; make test" ]
