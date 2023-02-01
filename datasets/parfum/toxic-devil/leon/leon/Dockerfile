FROM fusuf/whatsasena:latest

RUN git clone https://github.com/TOXIC-DEVIL/Leon /root/Leon
WORKDIR /root/Leon/
ENV TZ=Europe/Istanbul
RUN npm install supervisor -g
RUN yarn install --ignore-engines

CMD ["node", "bot.js"]
