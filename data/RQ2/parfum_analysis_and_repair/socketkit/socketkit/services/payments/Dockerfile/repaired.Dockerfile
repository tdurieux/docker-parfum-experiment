FROM mhart/alpine-node:16

ENV NODE_ENV=production
ENV PORT=3005
ENV TZ=UTC

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.6 && \
  wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
  chmod +x /bin/grpc_health_probe

COPY package*.json ./
RUN npm install --prefer-offline --no-audit --progress=false --only=production && npm cache clean --force;
COPY . .
EXPOSE 3005

CMD ["npm", "start"]
