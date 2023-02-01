FROM --platform=linux/arm/v7 arm32v7/fedora:latest

RUN useradd -rm olivetin -u 1000 

RUN mkdir -p /config /var/www/olivetin \
    && \
    dnf install -y \ 
		iputils \
		openssh-clients \
    && dnf clean all && \
    rm -rf /var/cache/dnf 

EXPOSE 1337/tcp 

VOLUME /config

COPY OliveTin /usr/bin/OliveTin
COPY webui /var/www/olivetin/

USER olivetin

ENTRYPOINT [ "/usr/bin/OliveTin" ]