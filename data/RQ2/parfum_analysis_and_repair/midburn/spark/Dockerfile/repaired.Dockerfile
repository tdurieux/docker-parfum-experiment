FROM node:8
RUN apt-get update && apt-get install --no-install-recommends -y build-essential mysql-client && rm -rf /var/lib/apt/lists/*;

RUN adduser --system spark
COPY .npmrc .yarnrc package.json yarn.lock /home/spark/
RUN chown -R spark /home/spark/
USER spark
RUN cd /home/spark && yarn install --ignore-scripts --pure-lockfile && yarn cache clean;
RUN cd /home/spark && npm rebuild node-sass --force

USER root
COPY . /home/spark
WORKDIR /home/spark
RUN cd public && npm install && npm cache clean --force;

ENV PATH="/home/spark/node_modules/.bin:${PATH}"

ENTRYPOINT ["/home/spark/entrypoint.sh"]
