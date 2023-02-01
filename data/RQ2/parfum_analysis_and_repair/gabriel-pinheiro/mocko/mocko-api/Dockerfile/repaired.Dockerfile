FROM node:12-alpine AS builder

WORKDIR /home/mocko
COPY package.json .
COPY package-lock.json .

RUN npm set progress=false
RUN npm install --only=production && npm cache clean --force;
RUN cp -R node_modules /home/prod_modules
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build


FROM node:12-alpine

WORKDIR /home/mocko
COPY --from=builder /home/prod_modules ./node_modules
COPY --from=builder /home/mocko/dist ./dist
COPY default.env .

CMD ["node", "dist/main"]
