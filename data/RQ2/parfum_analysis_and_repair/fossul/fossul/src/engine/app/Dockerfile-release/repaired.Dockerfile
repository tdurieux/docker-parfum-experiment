FROM fedora:latest


LABEL ios.k8s.display-name="fossul-server" \
    maintainer="Keith Tenzer <ktenzer@redhat.com>"

RUN mkdir /app && \
    mkdir /app/plugins

RUN groupadd -r fossul &&\
    useradd -r -g fossul -d /app -u 1001 -s /sbin/nologin -c "Fossul user" fossul

ENV GOBIN=/app
ENV HOME=/app

RUN curl -f -L https://github.com/fossul/fossul/releases/download/latest/openshift-client-linux-4.2.8.tar.gz | tar xz; cp oc kubectl /app && \
    curl -f -L https://github.com/fossul/fossul/releases/download/latest/app-service.tar.gz | tar xz -C /app && \
    curl -f -L https://github.com/fossul/fossul/releases/download/latest/plugins-app.tar.gz | tar xz -C /app/plugins

RUN chown -R fossul:fossul /app && \
    chmod -R 775 /app && \
    chmod -R 777 /tmp

RUN echo "1.0" > /etc/imageversion

USER fossul

WORKDIR /app

CMD /app/fossul-app-startup.sh
