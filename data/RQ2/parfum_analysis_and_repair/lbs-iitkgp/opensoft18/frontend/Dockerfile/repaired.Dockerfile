FROM ubuntu:16.04

RUN apt-get update \
&& apt-get install --no-install-recommends -y \
   wget \
   curl \
   build-essential \
   sudo \
   mesa-utils \
   apt-transport-https ca-certificates \
   python3-pip \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN mkdir /frontend
COPY . /frontend

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
&& apt-get install --no-install-recommends -y nodejs \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends yarn \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /frontend

RUN yarn && yarn cache clean;
RUN yarn global add serve && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD ["serve", "-s", "build"]
