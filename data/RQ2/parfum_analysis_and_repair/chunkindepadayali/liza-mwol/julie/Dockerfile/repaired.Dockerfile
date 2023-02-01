FROM fusuf/whatsasena:latest

RUN git clone https://github.com/Chunkindepadayali/LIZA-MWOL /root/WhatsAsenaDuplicated
WORKDIR /root/WhatsAsenaDuplicated/
ENV TZ=Asia/Kolkata
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --no-audit && yarn cache clean;
RUN git clone https://github.com/Chunkindepadayali/media

CMD ["node", "bot.js"]
