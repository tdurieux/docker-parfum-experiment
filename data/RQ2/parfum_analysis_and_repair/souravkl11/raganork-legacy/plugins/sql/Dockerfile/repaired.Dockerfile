FROM fusuf/whatsasena:latest

RUN git clone https://github.com/souravkl11/Raganork-legacy /skl/Raganork
WORKDIR /skl/Raganork
ENV TZ=Asia/Kolkata
RUN npm install supervisor -g && npm cache clean --force;
RUN npm install && npm cache clean --force;
CMD ["node", "index.js"]
