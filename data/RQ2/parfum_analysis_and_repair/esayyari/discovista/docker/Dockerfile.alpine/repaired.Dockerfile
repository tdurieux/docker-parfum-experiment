FROM alpine:3.5
ENV R_VERSION 3.3.2

RUN apk  update && \
    apk add wget && \
    apk add git && \
    apk add python && \
    apk add make && \
    apk add g++ && \ 
    apk add ca-certificates curl && \
    curl -f --silent \
    --location https://github.com/sgerrand/alpine-pkg-R/releases/download/v3.2.3-r0/R-3.2.3-r0.apk --output /var/cache/apk/R-3.2.3-r0.apk \
    --location https://github.com/sgerrand/alpine-pkg-R/releases/download/v3.2.3-r0/R-dev-3.2.3-r0.apk --output /var/cache/apk/R-dev-3.2. \
    --location https://github.com/sgerrand/alpine-pkg-R/releases/download/v3.2.3-r0/R-doc-3.2.3-r0.apk --output /var/cache/apk/R-doc-3.2. && \
    apk add --allow-untrusted \
    /var/cache/apk/R-3.2.3-r0.apk \
    /var/cache/apk/R-dev-3.2.3-r0.apk \
    /var/cache/apk/R-doc-3.2.3-r0.apk && \
    rm -fr /var/cache/apk/*


RUN apk add --no-cache libcurl4-gnutls-dev && \
    apk add --no-cache libcairo2-dev && \
    apk add --no-cache libxt-dev && \
    apk add --no-cache libssl-dev && \
    apk add --no-cache libssh2-1-dev && \
    apk add --no-cache libssl1.0.0 && \
    apk add --no-cache libxml2-dev && \
    apk add --no-cache libssl-dev
RUN mkdir /repository && \
    cd /repository && \
    wget https://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz && \
    tar xzvf newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz && \
    cp newick-utils-1.6/src/nw* /bin && \
    rm  newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz

COPY  ./installRPackages.R /repository
RUN    Rscript --vanilla /repository/installRPackages.R
