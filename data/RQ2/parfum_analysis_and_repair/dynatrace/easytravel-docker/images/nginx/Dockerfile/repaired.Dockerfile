FROM nginx:1.20.1

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

# Deploy 'nginx.conf' file
COPY conf/nginx.conf /etc/nginx/nginx.conf

ENV  ET_RUNTIME_DEPS "curl netcat openssl"
RUN apt-get update && \
     apt-get install --no-install-recommends -y ${ET_RUNTIME_DEPS} && \
     rm -rf /var/lib/apt/lists/* /tmp/*

COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

EXPOSE 80
EXPOSE 8080
EXPOSE 9079

CMD /run-process.sh
