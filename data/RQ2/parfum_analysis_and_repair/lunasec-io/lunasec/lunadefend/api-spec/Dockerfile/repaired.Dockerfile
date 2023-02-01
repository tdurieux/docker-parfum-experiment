FROM swaggerapi/swagger-codegen-cli
 RUN apk add --no-cache python g++ make
 COPY . .
 RUN yarn install --production && yarn cache clean;
 CMD ["node", "src/index.js"]