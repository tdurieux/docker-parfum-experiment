FROM KTBwhitedevil:latest

RUN git clone https://github.com/terror-boy/WhiteDevil /root/whitedevil
WORKDIR /root/whitedevil/
ENV KL=Kerala/India
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --no-audit && yarn cache clean;
RUN git clone https://github.com/terror-boy/White

CMD ["node","white", "bot.js"]
