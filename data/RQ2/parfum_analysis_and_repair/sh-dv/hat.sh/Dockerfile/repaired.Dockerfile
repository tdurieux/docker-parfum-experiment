FROM node:alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . ./

ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build


FROM nginx:stable-alpine

COPY --from=builder /app/out /usr/share/nginx/html

EXPOSE 3991

ENTRYPOINT ["nginx", "-g", "daemon off;"]