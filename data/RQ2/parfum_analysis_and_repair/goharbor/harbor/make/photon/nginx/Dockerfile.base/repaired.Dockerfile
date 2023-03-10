FROM photon:4.0

RUN tdnf install -y nginx shadow >> /dev/null \
    && tdnf clean all \
    && groupadd -r -g 10000 nginx && useradd --no-log-init -r -g 10000 -u 10000 nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log