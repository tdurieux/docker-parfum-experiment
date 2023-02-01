FROM souravkl11/raganork:test

RUN git clone https://github.com/souravkl11/Raganork/ /skl/raganork
WORKDIR /skl/raganork
ENV TZ = Asia/Kolkata
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --no-audit && yarn cache clean;

CMD ["node", "raganork.js"]
