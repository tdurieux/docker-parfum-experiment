FROM node:13
WORKDIR /app
RUN apt-get update && apt install --no-install-recommends -y mongodb && rm -rf /var/lib/apt/lists/*;
COPY ./package.json /app
RUN npm install && npm cache clean --force;
COPY ./mongo.js /app
COPY ./data /app
RUN chmod +x start.sh
CMD /app/start.sh