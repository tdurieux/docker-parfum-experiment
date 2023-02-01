FROM node:18-alpine

ARG SHOPIFY_API_KEY
ENV SHOPIFY_API_KEY=$SHOPIFY_API_KEY
EXPOSE 8081
WORKDIR /app
COPY web .
RUN npm install && npm cache clean --force;
RUN cd frontend && npm install && npm run build && npm cache clean --force;
CMD ["npm", "run", "serve"]
