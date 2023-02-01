FROM debian:stable-slim
WORKDIR /template
VOLUME /config
RUN apt-get -y update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
COPY setup.sh ./
COPY files ./files
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
