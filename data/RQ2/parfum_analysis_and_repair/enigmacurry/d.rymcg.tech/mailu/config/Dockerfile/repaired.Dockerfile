FROM debian:stable-slim
WORKDIR /template
VOLUME /overrides/postfix
RUN apt-get -y update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
COPY overrides/ setup.sh ./
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
