FROM node:10.4.1

COPY . /app
WORKDIR /app
EXPOSE 3030
CMD ["npm","run", "dev"]