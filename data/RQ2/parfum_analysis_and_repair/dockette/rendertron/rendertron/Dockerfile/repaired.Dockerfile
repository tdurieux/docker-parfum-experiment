FROM node:15-slim

RUN apt update && apt dist-upgrade -y && \
	apt install --no-install-recommends -y wget gnupg2 && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get -y --no-install-recommends install google-chrome-stable libxss1 && rm -rf /var/lib/apt/lists/*;

ADD ./ /srv

RUN npm --prefix /srv install && \
    npm --prefix /srv run build && \
    rm -Rf /tmp/* && \
    rm -Rf /var/lib/apt/lists/* && npm cache clean --force;

WORKDIR /srv

CMD npm run start
