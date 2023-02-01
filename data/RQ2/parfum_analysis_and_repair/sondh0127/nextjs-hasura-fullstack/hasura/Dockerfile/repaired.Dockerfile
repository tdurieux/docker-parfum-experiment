FROM hasura/graphql-engine:v1.3.2.cli-migrations-v2

# Copy migrations directory
COPY ./migrations /hasura-migrations

# Copy metadata directory
COPY ./metadata /hasura-metadata

# Enable the console
ENV HASURA_GRAPHQL_ENABLE_CONSOLE=true

# Enable debugging mode. It should be disabled in production.
ENV HASURA_GRAPHQL_DEV_MODE=true

# Heroku hobby tier PG has few limitations including 20 max connections
# https://devcenter.heroku.com/articles/heroku-postgres-plans#hobby-tier
ENV HASURA_GRAPHQL_PG_CONNECTIONS=15

# https://github.com/hasura/graphql-engine/issues/4651#issuecomment-623414531
ENV HASURA_GRAPHQL_CLI_ENVIRONMENT=default

# https://github.com/hasura/graphql-engine/issues/5172#issuecomment-653774367
ENV HASURA_GRAPHQL_MIGRATIONS_DATABASE_ENV_VAR=DATABASE_URL

# Enable JWT
ENV HASURA_GRAPHQL_JWT_SECRET=HASURA_GRAPHQL_JWT_SECRET

# Secure the GraphQL endpoint
ENV HASURA_GRAPHQL_ADMIN_SECRET=HASURA_GRAPHQL_ADMIN_SECRET

# Change $DATABASE_URL to your heroku postgres URL if you're not using
# the primary postgres instance in your app
CMD graphql-engine \
  --database-url $DATABASE_URL \
  serve \
  --server-port $PORT