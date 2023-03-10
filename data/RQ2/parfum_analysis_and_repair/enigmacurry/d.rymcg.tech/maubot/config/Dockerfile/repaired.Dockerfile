FROM debian:stable-slim
WORKDIR /template
RUN apt-get -y update && apt-get install --no-install-recommends -y gettext && rm -rf /var/lib/apt/lists/*;
COPY config.template.yaml setup.sh ./
RUN chmod a+x setup.sh
CMD ["./setup.sh"]
