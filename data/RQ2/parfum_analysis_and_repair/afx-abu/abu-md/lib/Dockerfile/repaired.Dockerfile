FROM fusuf/whatsasena:latest

RUN git clone https://github.com/Afx-Abu/abu-md /jsl/Abu
WORKDIR /jsl/Abu
ENV TZ=Asia/Kolkata
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --ignore-engines && yarn cache clean;

CMD ["node", "index.js"]
