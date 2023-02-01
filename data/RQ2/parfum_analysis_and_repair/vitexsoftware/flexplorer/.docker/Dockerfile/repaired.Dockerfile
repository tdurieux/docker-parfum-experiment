FROM php:7
MAINTAINER info@vitexsoftware

RUN wget -O - https://v.s.cz/info@vitexsoftware.cz.gpg.key | apt-key add -
RUN echo deb http://v.s.cz/ stable main | sudo tee /etc/apt/sources.list.d/vitexsoftware.list
RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y zlib1g-dev git && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip mbstring
RUN apt install -y --no-install-recommends composer && rm -rf /var/lib/apt/lists/*;

FROM vitexsoftware/easephpframework
FROM vitexsoftware/flexipeehp
COPY src/ /usr/share/flexplorer
COPY debian/conf/composer.json /usr/share/flexplorer/composer.json


ENTRYPOINT ["/data/.docker/entrypoint.sh"]
CMD ["tests"]
