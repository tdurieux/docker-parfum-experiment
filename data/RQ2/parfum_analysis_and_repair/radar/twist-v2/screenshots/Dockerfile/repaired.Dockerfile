FROM node:8.12

RUN apt-get update

# Install Chrome
RUN apt-get install --no-install-recommends apt-transport-https -y && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install --no-install-recommends google-chrome-stable -y && rm -rf /var/lib/apt/lists/*;
