FROM node:4-slim
RUN npm install -g rainbow-dns && npm cache clean --force;
ENTRYPOINT ["rainbow-dns"]
