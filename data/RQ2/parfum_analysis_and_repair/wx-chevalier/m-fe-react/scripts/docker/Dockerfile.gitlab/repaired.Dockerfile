FROM mhart/alpine-node:latest as builder

# 安装与编译代码
COPY . /app
WORKDIR /app

RUN yarn install --frozen-lockfile --registry https://registry.npm.taobao.org/ && yarn cache clean;
RUN yarn build && yarn cache clean;
RUN find . -name '*.map' -type f -exec rm -f {} \;

# 最终的应用
FROM abiosoft/caddy
COPY --from=builder /app/build /srv
EXPOSE 2015
