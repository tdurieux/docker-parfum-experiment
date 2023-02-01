# Build
FROM node:16-buster-slim
WORKDIR /opt/tallycoin_connect
COPY . .
RUN npm install && npm cache clean --force;

# Configure and start app
EXPOSE 8123
ENV NODE_ENV production
ENTRYPOINT ["npm"]
CMD ["start"]
