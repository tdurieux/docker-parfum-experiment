FROM parseplatform/parse-server:latest

# Install necessary dependencies and setup folders a root
USER root
RUN apk add --no-cache bash && apk add --no-cache postgresql-client
RUN npm install --production netreconlab/parse-server-carekit#main parse-server-any-analytics-adapter@^1.x.x @analytics/google-analytics@^0.5.x && npm cache clean --force;
RUN npm install --force --production parse-hipaa-dashboard@^1.x.x clamscan@^2.x.x @parse/s3-files-adapter@^1.x.x parse-server-api-mail-adapter@^2.x.x newrelic@^8.x.x && npm cache clean --force;
RUN npm install --production pm2@^5.x.x -g && npm cache clean --force;
RUN mkdir ./files
COPY ./scripts/ ./scripts/
RUN chmod +x ./scripts/wait-for-postgres.sh ./scripts/parse_idempotency_delete_expired_records.sh ./scripts/setup-dbs.sh ./scripts/setup-parse-index.sh ./scripts/setup-pgaudit.sh
RUN chown -R node ./files ./scripts

# Complete parse-hipaa setup as node
USER node
COPY ./ecosystem.config.js ./
COPY ./process.yml ./
COPY ./index.js ./
COPY ./parse-dashboard-config.json ./
COPY ./cloud/ ./cloud/

ENV CLUSTER_INSTANCES=1

ENTRYPOINT []
CMD ["./scripts/wait-for-postgres.sh", "node", "index.js"]
