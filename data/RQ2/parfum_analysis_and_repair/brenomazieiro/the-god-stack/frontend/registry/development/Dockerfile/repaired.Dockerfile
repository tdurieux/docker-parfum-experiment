FROM node:14.16.1-buster-slim

WORKDIR /opt/app-root/src

RUN apt update -y
RUN apt install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y dumb-init && rm -rf /var/lib/apt/lists/*;
# RUN chown node:node /opt/app-root/src
# USER node

CMD [ "dumb-init", "node" ]
