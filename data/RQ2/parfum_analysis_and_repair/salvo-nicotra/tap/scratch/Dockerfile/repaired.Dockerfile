FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y goaccess && touch /usr/local/apache2/access.log && rm -rf /var/lib/apt/lists/*;

COPY public_html/* /usr/local/apache2/htdocs/
COPY conf/* /usr/local/apache2/conf/

#ENTRYPOINT  ["goaccess","/usr/local/apache2/access.log", "-o /usr/local/apache2/htdocs/report.html", "--log-format=COMBINED", "--real-time-html"]