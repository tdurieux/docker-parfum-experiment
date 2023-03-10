FROM backend:builder as builder


FROM keymetrics/pm2:12-alpine

ENV TZ=Asia/Shanghai
RUN apk add tzdata --no-cache && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

RUN apk add git --no-cache
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/package-lock.json package-lock.json
RUN npm install --production && npm cache clean --force;

# 复制
COPY --from=builder /app/dist/ .

EXPOSE 80

CMD ["npm", "run", "docker-run"]
