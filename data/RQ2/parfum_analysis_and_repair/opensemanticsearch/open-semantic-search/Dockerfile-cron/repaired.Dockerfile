FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes cron curl \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY src/open-semantic-search-apps/etc/cron.d/open-semantic-search /etc/cron.d/open-semantic-search

RUN adduser --system --group --disabled-password opensemanticetl \
    && sed -i s/localhost/apps/ /etc/cron.d/open-semantic-search

CMD ["cron", "-f"]