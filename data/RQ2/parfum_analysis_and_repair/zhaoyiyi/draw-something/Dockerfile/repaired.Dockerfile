FROM node:12
ENV PORT=${PORT}
ADD . /app
WORKDIR /app
RUN apt-get update \
  && apt-get install -y --no-install-recommends -qq build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]