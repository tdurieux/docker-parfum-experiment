FROM        alpine
MAINTAINER  Gonkulator Labs <github.com/gonkulator>
COPY        setup.yml /etc/ansible/
COPY        entrypoint.sh /usr/bin/entrypoint
RUN chmod a+x /usr/bin/entrypoint && \
            apk add --no-cache --update python py-pip bash openssh-client openssl bash py-crypto ncurses && \
            pip install --no-cache-dir --upgrade ansible && mkdir -p /etc/ansible
VOLUME      /keys
CMD         /usr/bin/entrypoint