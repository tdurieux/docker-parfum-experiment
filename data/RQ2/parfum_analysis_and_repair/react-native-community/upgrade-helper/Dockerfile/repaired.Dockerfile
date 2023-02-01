FROM buildkite/puppeteer:latest

# Fix emojis not loading
RUN apt-get update -y && apt-get install --no-install-recommends -y fonts-noto-color-emoji && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn --no-cache --frozen-lockfile

COPY . .