FROM    node:8
WORKDIR /usr/src/app
COPY    . .
RUN     echo "deb http://ftp.uk.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt update && apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
EXPOSE  6612
CMD     ["bash", "runner.sh"]