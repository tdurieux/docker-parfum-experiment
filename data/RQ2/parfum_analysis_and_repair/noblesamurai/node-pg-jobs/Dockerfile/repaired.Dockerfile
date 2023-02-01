FROM node:0.12
RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
ADD ./package.json /code/package.json
WORKDIR /code
RUN npm install && npm cache clean --force;
ADD . /code
CMD [ "sh", "./start.sh" ]
