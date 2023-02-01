FROM certbot-compatibility-test
MAINTAINER Brad Warren <bmw@eff.org>

RUN apt-get install --no-install-recommends apache2 -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "certbot-compatibility-test", "-p", "apache" ]
