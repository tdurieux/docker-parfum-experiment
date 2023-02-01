FROM node
EXPOSE 1234
RUN apt-get update && apt-get install --no-install-recommends -y osmctools && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y
COPY . .
WORKDIR /server
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
