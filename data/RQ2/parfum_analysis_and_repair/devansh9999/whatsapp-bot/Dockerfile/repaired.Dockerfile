FROM buildkite/puppeteer:latest

RUN apt update && apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . /app
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
EXPOSE 8080