FROM node:16
RUN apt update && apt install --no-install-recommends -y \
        default-jre && rm -rf /var/lib/apt/lists/*;
# Create app directory
WORKDIR /app
ADD . /app/

RUN npm install --save --legacy-peer-deps && npm cache clean --force;
RUN npm run build

ENV HOST 0.0.0.0
EXPOSE 3000

# start command
CMD [ "npm", "run", "prod" ]
