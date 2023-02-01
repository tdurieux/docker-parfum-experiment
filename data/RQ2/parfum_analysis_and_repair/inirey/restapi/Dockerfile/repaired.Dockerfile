FROM node:16.13.0

RUN apt-get update && apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;
CMD ["node", "index.js"]
EXPOSE 6892
