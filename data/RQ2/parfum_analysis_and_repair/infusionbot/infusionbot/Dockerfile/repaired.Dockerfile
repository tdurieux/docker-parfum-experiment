FROM node:16
RUN mkdir -p /src/user/app
WORKDIR /src/user/app
COPY . .
RUN npm install -g npm && npm cache clean --force;
RUN npm install --production && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
EXPOSE 8080
CMD ["npm", "start"]
