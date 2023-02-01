FROM node:16
WORKDIR /build
RUN apt update && apt install --no-install-recommends ffmpeg libavahi-compat-libdnssd-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir guessit
COPY . .
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm i sqlite3 && npm cache clean --force;
RUN mkdir /etc/oblecto
EXPOSE 8080 9131 9132
CMD [ "node", "dist/bin/oblecto", "start" ]
