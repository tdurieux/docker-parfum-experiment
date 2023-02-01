FROM node:14 as build
WORKDIR /backend
COPY package*.json .
RUN npm install && npm cache clean --force;
COPY . .
RUN npm install --only=production && npm run build && rm -rf src && npm cache clean --force;

FROM node:14
COPY --from=build /backend /backend
WORKDIR /backend
EXPOSE 5001
CMD npm run migration:production wait-and-up && npm run start:production
