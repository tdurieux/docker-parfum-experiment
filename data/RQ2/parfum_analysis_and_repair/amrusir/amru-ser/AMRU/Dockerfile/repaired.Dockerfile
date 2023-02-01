FROM fusuf/whatsasena:latest

RUN git clone https://github.com/AMRUSIR/AMRU-SER /root/WhatsAsenaDuplicated
WORKDIR /root/WhatsAsenaDuplicated/
ENV TZ=Asia/Kolkata
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --ignore-engines && yarn cache clean;

CMD ["node", "bot.js"]
