FROM node

# SAMPCTL
COPY sampctl-install-deb-sudo.sh /
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install --no-install-recommends -y g++-multilib git ca-certificates && \
    sh /sampctl-install-deb-sudo.sh && rm -rf /var/lib/apt/lists/*;

# FIREJAIL
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y firejail && rm -rf /var/lib/apt/lists/*;

# SA-MP PAWN FIDDLE
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;

WORKDIR /usr/src/app/ui
COPY ./ui/package.json .
COPY ./ui/yarn.lock .
RUN yarn install && yarn cache clean;

WORKDIR /usr/src/app
COPY . .
RUN npm run compile

#WORKDIR /usr/src/app/ui
#RUN yarn build

WORKDIR /usr/src/app
ENTRYPOINT [ "npm", "start" ]
