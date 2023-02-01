FROM node:16
RUN mkdir munetic_admin
WORKDIR /munetic_admin
COPY . .
RUN npm i esbuild && npm cache clean --force;
RUN npm i && npm cache clean --force;
CMD [ "npm", "run", "dev" ]
