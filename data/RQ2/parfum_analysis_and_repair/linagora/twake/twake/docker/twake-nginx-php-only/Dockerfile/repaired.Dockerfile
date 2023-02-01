FROM debian:11

RUN apt-get update && apt-get -y --no-install-recommends install cron && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    nginx && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/sites-enabled/default

RUN usermod -u 1000 www-data

RUN apt-get remove certbot
RUN apt-get install --no-install-recommends -y python3 python3-venv libaugeas0 && rm -rf /var/lib/apt/lists/*;
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
RUN /opt/certbot/bin/pip install certbot
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

ADD docker/twake-nginx-php-only/nginx.conf /etc/nginx/nginx.conf

# Install yarn
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates apt-utils gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get -y --no-install-recommends install yarn && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN yarn global add webpack && yarn cache clean;
RUN yarn global add webpack-cli && yarn cache clean;
RUN apt-get update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

# Install php

ADD docker/twake-nginx/site.conf /etc/nginx/sites-available/site.template
ADD docker/twake-nginx-php-only/nginx.conf /etc/nginx/nginx.conf
RUN apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*;

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

COPY docker/twake-nginx-php-only/entrypoint.sh /
RUN chmod 0777 /entrypoint.sh
ENTRYPOINT /entrypoint.sh

EXPOSE 80
EXPOSE 443
