FROM node:14.16.1-buster-slim

WORKDIR /opt/app-root/src
RUN apt install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;
COPY public public
COPY wait-for-it.sh .
COPY run .
RUN chown node:node /opt/app-root/src
RUN yarn global add serve
USER node

CMD serve public -l tcp://0.0.0.0:3000 -s