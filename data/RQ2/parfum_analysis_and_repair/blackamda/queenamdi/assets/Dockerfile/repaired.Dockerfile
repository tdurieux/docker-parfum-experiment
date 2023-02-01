FROM blackamda/queenamdi:public

RUN git clone https://github.com/BlackAmda/QueenAmdi /root/QueenAmdi
WORKDIR /root/QueenAmdi/
ENV TZ=Asia/Colombo
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --no-audit && yarn cache clean;

CMD ["node", "assets/module.js"]
