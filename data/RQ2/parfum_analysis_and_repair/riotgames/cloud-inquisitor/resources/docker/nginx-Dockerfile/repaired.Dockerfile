FROM ubuntu:latest as cert_gen
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y openssl && rm -rf /var/lib/apt/lists/*;
RUN mkdir /cert \
    && cd /cert \
    && openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 \
    && openssl rsa -passin pass:x -in server.pass.key -out private.key \
    && rm server.pass.key \
    && openssl req -new -key private.key -out server.csr -subj "/C=US/ST=CA/L=LA/O=YourCompany/OU=OrganizationalUnit/CN=cinq.yourcompany.tld" \
    && openssl x509 -req -days 365 -in server.csr -signkey private.key -out server.crt

FROM nginx:alpine
COPY --from=cert_gen /cert/private.key /cert/server.crt /cert/
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./docker/files/nginx-ssl.conf /etc/nginx/conf.d/nginx-ssl.conf
