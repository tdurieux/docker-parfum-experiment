FROM quay.io/souravkl11/raganork:multidevice

RUN git clone https://github.com/souravkl11/Raganork /skl/Raganork
WORKDIR /skl/Raganork
ENV TZ=Asia/Kolkata
RUN npm install supervisor -g
RUN npm install
CMD ["node", "index.js"]
