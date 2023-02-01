ARG tag
FROM tykio/tyk-gateway:${tag}

RUN apt-get update && apt-get install --no-install-recommends -y busybox && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
ADD . .
RUN rm -f bundle.zip && /opt/tyk-gateway/tyk bundle build -y
ENTRYPOINT [ "busybox" ]
CMD [ "httpd", "-f", "-p", "0.0.0.0:80" ]
