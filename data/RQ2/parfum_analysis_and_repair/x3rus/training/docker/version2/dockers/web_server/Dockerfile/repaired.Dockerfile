FROM ubuntu:16.04
MAINTAINER Boutry Thomas "thomas.boutry@x3rus.com"

# install apps
RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 vim && rm -rf /var/lib/apt/lists/*;

COPY start.sh /
EXPOSE 80

CMD ["/start.sh"]
