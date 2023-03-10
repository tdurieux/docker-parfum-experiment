FROM elixir:1.7.3-slim as builder

# Before running following commands, configure
# 1. 'env/local.env' file.
# 2. `/apps/snitch_core/config/dev.exs' file

EXPOSE 4000
EXPOSE 3000

ENV APP_HOME /avia-backend
ENV AWS_ACCESS_KEY_ID dasdas
ENV AWS_SECRET_ACCESS_KEY dasdas
ENV BUCKET_NAME dsadas
ENV AWS_REGION dasda
ENV SENDGRID_API_KEY dassad
ENV PASSWORD_RESET_SALT dsadas
ENV TOKEN_MAXIMUM_AGE sdasda
ENV FRONTEND_CHECKOUT_URL http://localhost:4200/checkout/
ENV HOSTED_PAYMENT_URL http://localhost:3000/api/v1/hosted-payment/
ENV SUPPORT_URL https://admin.aviacommerce.org
ENV WKHTML_PATH /usr/bin/wkhtmltopdf
ENV ELASTIC_HOST http://localhost:9200/
ENV DB_HOST db

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

#Install git
RUN apt-get update \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Install essential packages for application build
RUN apt-get clean \
  && apt-get update \
  && apt-get install --no-install-recommends -y apt-utils apt-transport-https curl git make inotify-tools gnupg g++ \
  && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -f -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;

# Umbrella
COPY mix.exs mix.lock ./
COPY config config

# Apps
COPY apps apps
RUN mix do local.hex --force, local.rebar --force
RUN mix do deps.get, deps.compile

RUN apt-get clean \
  && apt-get update \
  && apt-get -y --no-install-recommends install curl tar file xz-utils build-essential cron \
  && apt-get -y --no-install-recommends install python-certbot-nginx \
  && apt-get -y --no-install-recommends install imagemagick wkhtmltopdf xvfb \
  # Resolves issue `QXcbConnection: Could not connect to display`
  # https://github.com/JazzCore/python-pdfkit/wiki/Using-wkhtmltopdf-without-X-server#debianubuntu
  && printf '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh \
  && chmod a+x /usr/bin/wkhtmltopdf.sh \
  && ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf \
  && apt-get install -y --no-install-recommends locales \
  # Supress earlang vm waning form locale issue
  && export LANG=en_US.UTF-8 \
  && echo $LANG UTF-8 > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=$LANG \
  # Remove unwanted package after use
  && apt-get purge -y curl file xz-utils build-essential locales \
  && apt-get -y autoremove \
  && apt-get -y clean && rm -rf /var/lib/apt/lists/*;


RUN cd apps/admin_app/assets \
  && yarn install && yarn cache clean;

RUN ["chmod", "+x", "./config/docker/dev/docker-dev-provision.sh"]

CMD ["./config/docker/dev/docker-dev-provision.sh"]
