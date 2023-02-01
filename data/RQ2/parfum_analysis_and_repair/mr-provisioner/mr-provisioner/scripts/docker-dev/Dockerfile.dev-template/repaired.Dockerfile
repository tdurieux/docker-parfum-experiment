FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y vim python3 python3-pip postgresql libpq-dev build-essential libssl-dev curl sudo less gnupg && rm -rf /var/lib/apt/lists/*;

# Node repo, curl | bash style 😩
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -

# Yarn repo 🚀
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

ENV APP_DATABASE_URI "postgresql+psycopg2://provuser:provuser@localhost/provisioner"
