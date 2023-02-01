FROM debian:buster
RUN apt-get update -q && apt-get install --no-install-recommends -yq python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN printf "[easy_install]\nallow_hosts=localhost\nfind_links=/dist\n" > /root/.pydistutils.cfg
