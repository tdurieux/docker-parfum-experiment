FROM httpd:2.4

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

RUN sed -i \
        -e 's/^#\(LoadModule .*proxy.so\)/\1/' \
        -e 's/^#\(LoadModule .*proxy_http.so\)/\1/' \
        conf/httpd.conf

RUN mkdir -p sites-enabled && \
    mkdir -p /assets && \
    echo "IncludeOptional sites-enabled/*.conf" >> conf/httpd.conf
