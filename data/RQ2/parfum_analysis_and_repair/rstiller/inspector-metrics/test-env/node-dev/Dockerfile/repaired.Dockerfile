FROM node:16

ARG TZ
ENV TZ=$TZ

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt update -y && apt install --no-install-recommends -y rsync sudo && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm-check @compodoc/compodoc pnpm && npm cache clean --force;
