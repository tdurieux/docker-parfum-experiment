FROM ubuntu

RUN apt-get update; apt-get install --no-install-recommends -y curl python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN echo "Install base Debian dependencies..." \
 && apt-get -y update \
 && apt-get -y --no-install-recommends install apt-transport-https lsb-release vim git curl sudo libpq5 gnupg2 \
 && pip3 install --no-cache-dir --upgrade pip setuptools wheel virtualenv && rm -rf /var/lib/apt/lists/*;

RUN echo "Install NodeJS and YARN..." \
 && curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;
