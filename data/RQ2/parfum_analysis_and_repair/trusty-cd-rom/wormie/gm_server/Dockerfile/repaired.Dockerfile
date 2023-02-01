FROM node

RUN apt-get update && apt-get install --no-install-recommends -y GraphicsMagick && rm -rf /var/lib/apt/lists/*;

RUN mkdir app

WORKDIR app

ADD . /app/

RUN npm install && npm cache clean --force;

EXPOSE 80

CMD ["npm", "start"]
