FROM node:12.18.4

WORKDIR /usr/src/ddd

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

ENV path /usr/src/ddd/node_modules/.bin:$PATH

COPY . /usr/src/ddd

RUN npm i -g dotenv-cli && npm cache clean --force;
RUN npm i && npm cache clean --force;

RUN cd public/app && npm i && npm cache clean --force;

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]