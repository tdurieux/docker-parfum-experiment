FROM datadog/squid

RUN apt update && apt install --no-install-recommends -y apache2-utils && rm -rf /var/lib/apt/lists/*;

RUN htpasswd -b -c /etc/squid/passwords userhttp passwordhttp

ADD squid.conf /etc/squid/squid.conf

RUN chmod o+rw /var/run

USER proxy
