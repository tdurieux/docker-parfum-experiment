FROM node:10.15.3-jessie as npm
MAINTAINER Lubos Kozmon <lubosh91@gmail.com>

# Copy source code
WORKDIR /app
COPY . .

# Install dependencies
RUN npm install -g @angular/cli \
  && npm install && npm cache clean --force;

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y google-chrome-stable \
  && rm -rf /var/lib/apt/lists/*

ENV CHROME_BIN=google-chrome

CMD ["npm", "run", "test:ci"]
