FROM quay.io/lyfe00011/test:beta

RUN git clone https://github.com/farhan-dqz/Julie-Mwol /root/WhatsAsenaDuplicated
WORKDIR /root/WhatsAsenaDuplicated/
RUN yarn install --no-audit && yarn cache clean;
RUN git clone https://github.com/farhan-dqz/media
RUN cp -R /root/Utils/* /root/WhatsAsenaDuplicated
CMD ["node", "bot.js"]
