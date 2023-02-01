FROM node:10.16.3

EXPOSE 8000

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
      g++ \
      gcc \
      make \
      python && rm -rf /var/lib/apt/lists/*;

RUN npm install --global gatsby --no-optional gatsby@latest && npm cache clean --force;

WORKDIR /app

COPY entry.sh package.json yarn.lock /app/
RUN yarn
COPY plugins/ plugins/
RUN yarn --cwd plugins/gatsby-remark-images-full-width
ENTRYPOINT ["/app/entry.sh"]
