FROM node:latest

RUN npm install gulp -g && npm cache clean --force;
RUN dpkg --add-architecture i386
RUN apt-get update && apt install --no-install-recommends wine32 zip -y && rm -rf /var/lib/apt/lists/*;

COPY . /opt/electron-windows-inno-installer
RUN cd /opt/electron-windows-inno-installer && npm install && npm cache clean --force;

ENTRYPOINT ["node", "/opt/electron-windows-inno-installer/cli.js"]
