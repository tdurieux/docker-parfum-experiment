FROM node:10-alpine
COPY . /workspace
WORKDIR /workspace
RUN npm install && npm cache clean --force;

FROM nginx:1.17-alpine
RUN apk add --no-cache --update nodejs npm git
RUN mkdir -p /usr/share/nginx/html && rm -rf /usr/share/nginx/html/*
WORKDIR /usr/share/nginx/html
COPY --from=0 /workspace/. .
RUN chmod +x start-frontend.sh
CMD ["sh", "./start-frontend.sh"]
