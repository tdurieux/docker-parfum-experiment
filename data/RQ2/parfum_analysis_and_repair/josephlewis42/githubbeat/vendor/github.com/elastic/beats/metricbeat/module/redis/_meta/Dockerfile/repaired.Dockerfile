FROM redis:3.2.4-alpine
HEALTHCHECK --interval=1s --retries=90 CMD nc -z localhost 6379