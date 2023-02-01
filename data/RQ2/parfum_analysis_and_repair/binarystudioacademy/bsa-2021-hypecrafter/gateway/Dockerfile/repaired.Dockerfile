FROM node:14.17.1-alpine3.13
WORKDIR "/app/shared"
COPY --from=mihailts/hypecrafter-shared /app .
WORKDIR "/app/gateway"
COPY . .
RUN npm install && npm cache clean --force;

EXPOSE 3001 3009
CMD ["npm", "run", "start-prod"]