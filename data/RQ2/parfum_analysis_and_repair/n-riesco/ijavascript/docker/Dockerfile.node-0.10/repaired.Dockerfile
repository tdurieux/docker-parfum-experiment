FROM node:0.10

# Removal of jessie-updates and jessie-backports from Debian mirrors
# https://www.lucas-nussbaum.net/blog/?p=947
RUN echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i "/deb http:\/\/deb.debian.org\/debian jessie-updates main/d" /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until no;" > /etc/apt/apt.conf.d/99no-check-valid-until

RUN apt-get update && \
    apt-get install -yq --no-install-recommends libzmq3-dev ipython-notebook && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Workaround: ensure node owns its own home folder
RUN mkdir -p /home/node && chown node:node /home/node

USER node

WORKDIR /home/node

COPY --chown=node:node . .

RUN rm -rf node_modules && npm install --save jp-kernel@1 jmp@1 && npm install && npm cache clean --force;

CMD npm run test:ijskernel && bin/ijsinstall.js
