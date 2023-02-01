FROM fusuf/whatsasena:latest

RUN git clone https://github.com/TOXIC-DEVIL/Leon /root/Leon
WORKDIR /root/Leon/
ENV TZ=Europe/Istanbul
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --ignore-engines && yarn cache clean;

CMD ["node", "bot.js"]
