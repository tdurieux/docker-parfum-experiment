FROM mcr.microsoft.com/playwright:focal as baserepo
ENV NODE_ENV='production'
WORKDIR /app
RUN npm install -g pnpm \
    && chown -R pwuser:pwuser /app


FROM baserepo as builder
WORKDIR /
RUN apt-get update \
    && apt-get install -y wget tini
USER pwuser
WORKDIR /app
COPY package* /app
RUN pnpm install --production false
COPY tsconfig.json /app/
COPY src /app/src
RUN pnpm build


FROM baserepo
ENV DOCKER=1
RUN apt-get update \
    && apt-get install -y tini
USER pwuser
COPY --from=builder --chown=pwuser:pwuser /app/package* /app/
RUN pnpm install --production
COPY --from=builder --chown=pwuser:pwuser /app/dist /app/dist
EXPOSE 3000
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD node -r dotenv/config dist/main.js
