FROM fxa-oauth-server:build

USER root
RUN rm -rf /app/node_modules
RUN rm -rf /app/fxa-content-server-l10n

USER app
RUN npm ci
