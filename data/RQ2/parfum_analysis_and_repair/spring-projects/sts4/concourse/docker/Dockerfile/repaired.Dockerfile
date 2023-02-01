FROM ubuntu:18.04

ADD npmrc /root/.npmrc

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  gettext-base \
  git \
  jq \
  openjdk-11-jdk \
  openjdk-11-source \
  curl \
  xvfb \
  icewm && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Install Google Chrome
RUN curl -f -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
 && apt-get update && apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN npm install -g vsce && npm cache clean --force;
RUN npm install -g ovsx && npm cache clean --force;

RUN yarn global add lerna

CMD /bin/bash 
