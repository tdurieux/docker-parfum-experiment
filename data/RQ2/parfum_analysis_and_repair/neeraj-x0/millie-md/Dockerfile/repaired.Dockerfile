FROM node:lts-buster
RUN git clone https://github.com/Neeraj-x0/Millie-MD /root/Neerajx0
WORKDIR /root/Neerajx0
ENV TZ=Asia/Kolkata
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  ffmpeg \
  webp && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;
COPY package.json .
RUN npm install && npm cache clean --force;
RUN npm install supervisor -g && npm cache clean --force;
RUN yarn install --ignore-engines && yarn cache clean;
CMD ["node", "index.js"]
