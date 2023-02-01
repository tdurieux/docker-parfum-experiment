FROM debian:buster-slim

### Install utilites
RUN apt-get update --fix-missing && apt-get -y upgrade && \
 apt-get install --no-install-recommends -y sudo curl wget gnupg \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

### Install node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
 sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# chrome
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&\
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&\
sudo apt-get update && \
 sudo apt-get install --no-install-recommends -y ${CHROME_VERSION:-google-chrome-stable} \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Chrome as a user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

# Run Chrome non-privileged
USER chrome

# Copy app
ENV APP_HOME /home/chrome/bnb_probe
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

# Build app
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN npm install && npm cache clean --force;

EXPOSE 3000
CMD ["npm", "start"]
