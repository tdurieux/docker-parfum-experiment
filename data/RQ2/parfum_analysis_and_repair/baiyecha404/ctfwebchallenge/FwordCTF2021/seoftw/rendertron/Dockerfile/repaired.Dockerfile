FROM node

RUN apt update && apt dist-upgrade -y && \
	apt install --no-install-recommends -y wget gnupg2 && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get -y --no-install-recommends install google-chrome-stable libxss1 && rm -rf /var/lib/apt/lists/*;


RUN git clone https://github.com/GoogleChrome/rendertron.git && cd rendertron && npm install && npm run build && npm cache clean --force;
WORKDIR /rendertron
CMD ["npm","run","start"]
