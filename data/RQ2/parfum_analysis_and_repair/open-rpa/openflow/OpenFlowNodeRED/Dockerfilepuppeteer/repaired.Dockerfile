FROM node:lts
EXPOSE 80
EXPOSE 5859
RUN apt-get update \
    && apt-get install --no-install-recommends -y wget gnupg python3-pip python3-venv php \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget sudo libgbm-dev libxshmfence1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \


WORKDIR /data
RUN groupadd -r openiapuser && useradd -r -g openiapuser -G audio,video openiapuser \
    && mkdir -p /home/openiapuser/Downloads \
    && chown -R openiapuser:openiapuser /home/openiapuser \
    && chown -R openiapuser:openiapuser /data/

COPY --chown=openiapuser:openiapuser docker-package.json ./package.json
RUN npm install --only=prod && npm cache clean --force;
# RUN npm install
COPY --chown=openiapuser:openiapuser dist ./

USER openiapuser
ENTRYPOINT ["/usr/local/bin/node", "--inspect=0.0.0.0:5859", "index.js"]
