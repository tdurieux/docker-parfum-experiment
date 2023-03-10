FROM quay.io/lyfe00011/test:beta

RUN git clone https://github.com/Ajmal-Achu/Nandhutty_v2 /root/WhatsAsenaDuplicated
WORKDIR /root/WhatsAsenaDuplicated/
RUN yarn install --no-audit && yarn cache clean;
RUN git clone https://github.com/Ajmal-Achu/Nandhuttynew
RUN cp -R /root/Utils/* /root/WhatsAsenaDuplicated
CMD ["node", "bot.js"]
