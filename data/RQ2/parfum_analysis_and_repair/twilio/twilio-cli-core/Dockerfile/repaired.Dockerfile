FROM node:8-jessie
RUN apt-get update && apt-get install --no-install-recommends -y libsecret-1-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /cli-core
WORKDIR /cli-core
COPY . .
RUN npm install ./cli-test && npm cache clean --force;
RUN npm install && npm cache clean --force;
CMD ["npm", "test"]
