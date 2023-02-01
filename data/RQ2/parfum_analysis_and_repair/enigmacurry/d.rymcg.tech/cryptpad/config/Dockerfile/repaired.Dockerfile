FROM debian:stable-slim
RUN apt-get -y update && apt-get install --no-install-recommends -y openssl gettext && rm -rf /var/lib/apt/lists/*;
WORKDIR /template
VOLUME /cryptpad/config
COPY config.template.js setup.sh ./
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
