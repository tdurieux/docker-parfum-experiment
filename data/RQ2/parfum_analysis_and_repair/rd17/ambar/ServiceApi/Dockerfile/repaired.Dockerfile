FROM node:8.10

# Set a timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . .
RUN yarn install && yarn cache clean;
RUN yarn run build && yarn cache clean;

CMD node dist

HEALTHCHECK --interval=5s --timeout=30s --retries=50 \
  CMD curl -f localhost:8081/api || exit 1
