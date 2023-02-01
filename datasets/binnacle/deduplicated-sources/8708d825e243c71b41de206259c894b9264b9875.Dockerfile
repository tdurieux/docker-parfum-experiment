# Build stage
FROM node:{{ version }}-alpine AS base
WORKDIR /app
COPY package.json .
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production --registry=https://registry.npm.taobao.org
RUN cp -R node_modules prod_node_modules
RUN npm install --registry=https://registry.npm.taobao.org

# Test stage
FROM base As test
COPY . /app
RUN npm test

# Release stage
FROM base AS release
COPY --from=base /app/prod_node_modules /app/node_modules
COPY . /app
CMD ["npm","start"]