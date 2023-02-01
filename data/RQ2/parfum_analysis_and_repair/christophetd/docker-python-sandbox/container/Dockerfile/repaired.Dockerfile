FROM node:argon

RUN ["adduser",  "--home",  "/usr/src/app", "--system", "sandboxuser"]
RUN ["chown", "-R", "sandboxuser", "/usr/src/app"]
RUN ["chmod", "-R", "u+rwx", "/usr/src/app"]

COPY ./shared /usr/src/app
RUN cd /usr/src/app && npm install && npm cache clean --force;

COPY start.sh /
RUN chmod 755 /start.sh

RUN apt-get update && apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*; # Install python 3


CMD ["/start.sh"]
