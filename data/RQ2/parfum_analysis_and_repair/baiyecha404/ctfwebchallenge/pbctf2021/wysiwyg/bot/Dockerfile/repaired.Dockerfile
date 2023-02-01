FROM ubuntu:focal-20210723

RUN apt update && \
      apt install --no-install-recommends -y curl && \
      curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
      apt install --no-install-recommends -y nodejs \
      && rm -rf /var/lib/apt/lists/*

RUN curl -f https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt update && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y google-chrome-unstable && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash user

RUN cd /home/user && PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install puppeteer && npm cache clean --force;

COPY bot.js /home/user/
COPY flag.txt /flag.txt

USER user
WORKDIR /home/user

CMD PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome /usr/bin/node /home/user/bot.js