FROM node:12

ENV HOME /Angular-Starter

WORKDIR ${HOME}
ADD . $HOME

# chrome --
ENV CHROME_BIN /usr/bin/chromium
ENV DISPLAY :99

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y xvfb chromium libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["Xvfb", "-ac", ":99", "-screen", "0", "1280x800x16"]
# -- chrome

# puppeteer --
RUN \
  apt-get update && apt-get install -y wget --no-install-recommends && \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install -y google-chrome-unstable --no-install-recommends && \
  apt-get purge --auto-remove -y curl && rm -rf /var/lib/apt/lists/*;
# -- puppeteer

RUN \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /src/*.deb

RUN npm install && npm cache clean --force;

EXPOSE 8000 5000
