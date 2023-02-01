# Build Stage
# ---
FROM node:16 AS builder
WORKDIR /opt/app

COPY package*.json ./
RUN npm install --omit optional && npm cache clean --force;
COPY . .
RUN npm run build
RUN rm -rf node_modules && npm i --production --ignore-scripts && npm cache clean --force;

# Run Stage
# ---
FROM gcr.io/distroless/nodejs:16

USER nobody

COPY --chown=nobody --from=builder /opt/app /opt/app
WORKDIR /opt/app

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ENV PATH /opt/node_app/node_modules/.bin:$PATH

CMD ["dist/main.js"]
