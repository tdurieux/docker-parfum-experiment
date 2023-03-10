FROM nginx-plus-s3-gateway

ENV OWASP_RULESET_VERSION "v3.3.0"
ENV OWASP_RULESET_CHECKSUM "1f4002b5cf941a9172b6250cea7e3465a85ef6ee"

# Install modsecurity from the NGINX Plus repository and download OWASP ruleset
RUN set -eux \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get -qq update; \
    apt-get -qq install --no-install-recommends --no-install-suggests -y curl libdigest-sha-perl nginx-plus-module-modsecurity; \
    curl -f -o /tmp/coreruleset.tar.gz --retry 6 -Ls "https://github.com/coreruleset/coreruleset/archive/${OWASP_RULESET_VERSION}.tar.gz"; \
    echo "${OWASP_RULESET_CHECKSUM}  /tmp/coreruleset.tar.gz" | shasum -c; \
    mkdir -p /usr/local/nginx/conf/owasp-modsecurity-crs; \
    tar -C /usr/local/nginx/conf/owasp-modsecurity-crs --strip-components 1 -xzf /tmp/coreruleset.tar.gz; rm /tmp/coreruleset.tar.gz \
    apt-get -qq purge curl libdigest-sha-perl; \
    rm -rf /var/lib/apt/lists/*

# Update configuration to load module
RUN sed -i '1s#^#load_module modules/ngx_http_modsecurity_module.so;\n#' /etc/nginx/nginx.conf

# Update configuration to include modsecurity
RUN sed -i 's#server {#server \{\n    include /etc/nginx/conf.d/gateway/modsecurity.conf;#' /etc/nginx/templates/default.conf.template

COPY etc/nginx /etc/nginx
COPY usr/local /usr/local
