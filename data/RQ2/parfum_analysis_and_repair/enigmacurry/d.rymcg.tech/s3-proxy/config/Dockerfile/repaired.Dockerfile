FROM debian:stable-slim
WORKDIR /template
VOLUME /proxy/conf
RUN apt-get -y update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
COPY s3-proxy.template.yml setup.sh ./
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
