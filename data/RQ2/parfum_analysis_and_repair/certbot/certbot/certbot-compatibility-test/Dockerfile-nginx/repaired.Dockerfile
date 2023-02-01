FROM certbot-compatibility-test
MAINTAINER Brad Warren <bmw@eff.org>

RUN apt-get install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "certbot-compatibility-test", "-p", "nginx" ]
