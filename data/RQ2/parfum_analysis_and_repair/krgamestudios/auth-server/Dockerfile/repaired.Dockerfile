FROM node:16
WORKDIR "/app"
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . /app
EXPOSE 3200
USER node
ENTRYPOINT ["bash", "-c"]
CMD ["sleep 10 && npm start"]
