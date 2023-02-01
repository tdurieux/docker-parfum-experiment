# docker build -t rc:latest .
# docker run -v `pwd`:/rc rc:latest

FROM node:12-buster

RUN apt update && apt install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

RUN npm -g config set user root
RUN npm install --global web-ext && npm cache clean --force;

RUN mkdir /rc

WORKDIR /rc

ENTRYPOINT ["./build_all.sh"]
