FROM nginx:stable

LABEL com.bitwarden.product="bitwarden"

ENV USERNAME="bitwarden"
ENV GROUPNAME="bitwarden"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gosu \
        curl && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy.conf /etc/nginx/proxy.conf
COPY mime.types /etc/nginx/mime.types
COPY security-headers.conf /etc/nginx/security-headers.conf
COPY security-headers-ssl.conf /etc/nginx/security-headers.conf

COPY setup-bwuser.sh /

EXPOSE 8000

EXPOSE 8080
EXPOSE 8443

RUN chmod +x /setup-bwuser.sh

RUN ./setup-bwuser.sh $USERNAME $GROUPNAME

RUN mkdir -p /var/run/nginx && \
    touch /var/run/nginx/nginx.pid
RUN chown -R $USERNAME:$GROUPNAME /var/run/nginx && \
    chown -R $USERNAME:$GROUPNAME /var/cache/nginx && \
    chown -R $USERNAME:$GROUPNAME /var/log/nginx
    

HEALTHCHECK CMD curl --insecure -Lfs https://localhost:8443/alive || curl -Lfs http://localhost:8080/alive || exit 1

USER bitwarden