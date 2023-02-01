FROM docker.io/node:14

# ENV PRISMA_ENDPOINT http://prisma:4466

WORKDIR /node_watcher

# To make the build fast
COPY package.json .
COPY yarn.lock .

# Install dependencies
RUN yarn

COPY ./ ./

# Create the database schema
CMD ["yarn", "prisma", "deploy"]

