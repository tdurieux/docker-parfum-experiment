FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

RUN apt-get update && apt-get install --no-install-recommends -yq lighttpd && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/lighttpd/lighttpd.conf
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

ADD index.html /app/index.html

EXPOSE 80
CMD lighttpd -f /etc/lighttpd/lighttpd.conf -D
