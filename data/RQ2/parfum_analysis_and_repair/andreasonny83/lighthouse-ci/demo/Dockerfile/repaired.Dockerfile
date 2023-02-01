FROM node:10

WORKDIR /demo

ENV CHROME_BIN=/usr/bin/google-chrome-stable
EXPOSE 8080

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .
