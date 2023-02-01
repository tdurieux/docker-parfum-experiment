FROM node:latest
COPY ./connect_sql.js .
RUN apt update -y && apt install --no-install-recommends nano -y && rm -rf /var/lib/apt/lists/*;
RUN npm install -g npm mysql ajax && npm cache clean --force;
RUN node connect_sql.js > data
