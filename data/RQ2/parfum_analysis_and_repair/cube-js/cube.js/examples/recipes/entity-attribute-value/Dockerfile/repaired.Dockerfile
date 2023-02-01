FROM cubejs/cube:latest

COPY . .
RUN npm install && npm cache clean --force;