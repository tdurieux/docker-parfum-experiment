FROM localhost/almond-cloud

USER root

COPY --chown=almond-cloud:almond-cloud ./tests /opt/almond-cloud/tests

RUN curl -sL https://rpmfind.net/linux/epel/7/x86_64/Packages/l/libpmem-1.1-1.el7.x86_64.rpm  -o libpmem-1.1-1.el7.x86_64.rpm && \
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash && \
    dnf -y install libpmem-1.1-1.el7.x86_64.rpm  MariaDB-client && \
    rm -f libpmem-1.1-1.el7.x86_64.rpm && rm -rf /var/cache/dnf

RUN dnf -y install gcc gcc-c++ && \
    curl -sL https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz -o go1.16.4.linux-amd64.tar.gz && \
    tar -xzf go1.16.4.linux-amd64.tar.gz && \
    mv go /usr/local
    
RUN /usr/local/go/bin/go get golang.org/x/tools/cmd/cover

WORKDIR /opt/almond-cloud/go
RUN /usr/local/go/bin/go test -cover -v ./...

WORKDIR /home/almond-cloud
RUN mkdir -p shared/download && mkdir -p shared/cache
RUN for x in devices icons backgrounds blog-assets template-files/en; \
      do mkdir -p shared/download/$x; \
    done
RUN echo '{"tt:stock_id:goog": "fb80c6ac2685d4401806795765550abdce2aa906.png"}' > shared/cache/index.json
RUN curl -sL https://thingpedia.stanford.edu/thingpedia/api/v3/devices/package/com.bing -o /opt/almond-cloud/tests/data/com.bing.zip



ENTRYPOINT ["/opt/almond-cloud/docker/start.sh"]