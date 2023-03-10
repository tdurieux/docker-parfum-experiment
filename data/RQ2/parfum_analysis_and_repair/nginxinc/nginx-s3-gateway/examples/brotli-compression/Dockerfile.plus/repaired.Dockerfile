FROM nginx-plus-s3-gateway

# Install Brolti from the NGINX Plus repository
RUN set -eux \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get -qq update; \
    apt-get -qq install --no-install-recommends --no-install-suggests -y nginx-plus-module-brotli; \
    rm -rf /var/lib/apt/lists/*

# Update configuration to load module
RUN sed -i '1s#^#load_module modules/ngx_http_brotli_filter_module.so;\n\n#' /etc/nginx/nginx.conf

COPY etc/nginx/conf.d /etc/nginx/conf.d