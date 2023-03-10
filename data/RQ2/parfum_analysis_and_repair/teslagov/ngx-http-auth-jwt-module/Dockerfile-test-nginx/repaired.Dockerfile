ARG BASE_IMAGE=teslagov/jwt-nginx:latest

FROM ${BASE_IMAGE} as NGINX
COPY resources/test-jwt-nginx.conf /etc/nginx/conf.d/test-jwt-nginx.conf
COPY resources/rsa_key_2048-pub.pem /etc/nginx/rsa-key.conf
RUN cp -r /usr/share/nginx/html /usr/share/nginx/secure \
  && cp -r /usr/share/nginx/html /usr/share/nginx/secure-rs256 \
  && cp -r /usr/share/nginx/html /usr/share/nginx/secure-rs256-file \
  && cp -r /usr/share/nginx/html /usr/share/nginx/secure-auth-header \
  && cp -r /usr/share/nginx/html /usr/share/nginx/secure-no-redirect