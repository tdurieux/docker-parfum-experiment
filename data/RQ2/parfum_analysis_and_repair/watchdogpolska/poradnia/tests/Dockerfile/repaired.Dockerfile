FROM cypress/base:14

RUN apt-get update && apt-get install --no-install-recommends -y wait-for-it && rm -rf /var/lib/apt/lists/*;

WORKDIR /e2e

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

RUN npx cypress verify

COPY . .

CMD ["npx", "cypress", "run"]
