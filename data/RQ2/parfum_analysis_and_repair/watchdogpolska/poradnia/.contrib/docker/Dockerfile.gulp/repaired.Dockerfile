FROM node:8
WORKDIR /app
VOLUME /app
CMD ["bash","-c", "npm install && npm rebuild node-sass && npx gulp build"]