ARG REDIS_VERSION

FROM redis:${REDIS_VERSION}

EXPOSE 6379