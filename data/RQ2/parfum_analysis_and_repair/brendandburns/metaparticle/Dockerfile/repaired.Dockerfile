# On ARM, use this: FROM hypriot/rpi-node:4.3.0-slim
FROM node:4

RUN npm install jayson q minimist loglevel harmony-proxy node-redis-client && npm cache clean --force;

ADD *js /
ADD examples/*js /

