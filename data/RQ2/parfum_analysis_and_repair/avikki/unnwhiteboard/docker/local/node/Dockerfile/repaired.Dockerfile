FROM node:14.18.1
WORKDIR /app
# COPY ["package.json", "package-lock.json*", "./"]
RUN npm install && npm cache clean --force;
# COPY . .
CMD ["npm", "run", "dev-server"]