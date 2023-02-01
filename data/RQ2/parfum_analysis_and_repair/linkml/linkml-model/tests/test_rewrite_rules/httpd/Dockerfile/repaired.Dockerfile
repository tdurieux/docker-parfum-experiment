FROM httpd:2.4

LABEL maintainer="Harold Solbrig <solbrig@jhu.edu>"
LABEL description="Test image for w3id.org"

COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./httpd-foreground /usr/local/bin

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y git && \
    git clone https://github.com/perma-id/w3id.org.git /w3id && \
    rm -rf /w3id/linkml && rm -rf /var/lib/apt/lists/*;

# Get am image of vim into the container
RUN apt-get update -y && \
    apt-get install --no-install-recommends apt-file -y && \
    apt-file update && \
    apt-get install --no-install-recommends vim -y && \
    rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

CMD ["httpd-foreground"]
EXPOSE 80 443
