FROM cs50/server
EXPOSE 8080

RUN npm i -g n && npm cache clean --force;
RUN n 6.9.4
