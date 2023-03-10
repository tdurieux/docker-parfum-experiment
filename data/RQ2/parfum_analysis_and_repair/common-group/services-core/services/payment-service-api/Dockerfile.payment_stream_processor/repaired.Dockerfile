FROM comum/payment-service:latest
WORKDIR /usr/app
COPY . .
RUN npm install && npm cache clean --force;
CMD pg-dispatcher --db-uri=$DATABASE_URL --tls-mode=$TLS_MODE --redis-uri=$REDIS_URL --channel=$DB_CHANNEL --workers=$WORKERS --exec="./main.js"
