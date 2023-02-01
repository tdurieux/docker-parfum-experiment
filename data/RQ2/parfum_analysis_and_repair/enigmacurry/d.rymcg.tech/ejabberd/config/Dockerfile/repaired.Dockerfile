FROM debian:stable-slim
WORKDIR /template
VOLUME /home/ejabberd/conf
RUN apt-get -y update && apt-get install --no-install-recommends -y openssl gettext && rm -rf /var/lib/apt/lists/*;
COPY ejabberd.template.yml setup.sh ./
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
