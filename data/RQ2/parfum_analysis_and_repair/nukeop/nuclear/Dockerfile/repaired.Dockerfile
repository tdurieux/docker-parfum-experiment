FROM node

WORKDIR /usr/src/
COPY . nuclear

RUN apt-get update && apt-get install --no-install-recommends -y libnss3 libgtk-3-0 libx11-xcb1 libxss1 libasound2 && rm -rf /var/lib/apt/lists/*;

WORKDIR nuclear
RUN npm install && npm run build:dist && npm run build:electron && npm run pack && npm cache clean --force;
RUN ls -a | grep -v release | xargs rm -rf || true

CMD ["./release/linux-unpacked/nuclear"]
