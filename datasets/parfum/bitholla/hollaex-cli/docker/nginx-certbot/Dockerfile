FROM nginx:1.15.8-alpine
RUN apk add --no-cache certbot py-pip && \
    apk add --no-cache --virtual .build-deps build-base libffi-dev openssl-dev python-dev && \
    pip install certbot-nginx && \
    apk del .build-deps
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]