FROM node:18

WORKDIR /usr/app
COPY ./server/ /usr/app

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 \
  python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install dbt-core dbt-snowflake dbt-redshift dbt-bigquery dbt-postgres

RUN NODE_ENV=production npm install && npm cache clean --force;

CMD ["node", "dist/index.js"]
EXPOSE $PORT