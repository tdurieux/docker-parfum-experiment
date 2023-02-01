FROM node:4.4.2
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
COPY dist /usr/bitbloq-backend
ENV MONGO_URL files_mongo_1
WORKDIR /usr/bitbloq-backend
RUN npm cache clean --force && npm install && npm cache clean --force;
CMD /bin/bash -c "sed -i 's@MONGO_URL@'"$MONGO_URL"'@g' /usr/bitbloq-backend/app/res/config.js && node index.js"
