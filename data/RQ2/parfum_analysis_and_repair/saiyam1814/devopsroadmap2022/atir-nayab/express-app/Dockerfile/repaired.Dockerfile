FROM node
WORKDIR /app
COPY package.json .
ARG NODE_ENV
RUN if [ "$NODE_ENV" = "development" ]; \
        then \
        npm install; npm cache clean --force; \
        else npm install --only=production; npm cache clean --force; \
        fi
COPY . .
ENV PORT 3000
EXPOSE $PORT
CMD ["npm","run","dev"]