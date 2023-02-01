# On ARM, use this: FROM hypriot/rpi-node:4.3.0-slim
FROM node:4

RUN npm install metaparticle && npm cache clean --force;

ADD *js /

