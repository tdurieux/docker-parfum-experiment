FROM node:16

RUN apt-get update && apt-get install --no-install-recommends -y unrtf par git openjdk-11-jre-headless curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://archive.apache.org/dist/tika/tika-app-1.22.jar >/tika.jar

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn --production
COPY ./ /app/
RUN yarn run build

ENV PATH=$PATH:/app/node_modules/.bin:/app/bin

VOLUME /app/public/data

EXPOSE 3000
CMD ["yarn", "start"]
