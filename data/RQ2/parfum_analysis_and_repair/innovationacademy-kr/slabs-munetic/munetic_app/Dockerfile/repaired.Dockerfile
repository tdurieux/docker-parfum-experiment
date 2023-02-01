FROM node:16
RUN mkdir munetic_app
WORKDIR /munetic_app
COPY . .
RUN npm i esbuild && npm cache clean --force;
RUN npm i && npm cache clean --force;
CMD [ "npm", "run", "dev" ]
