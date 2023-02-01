# 阶段1 构建前端
FROM node:latest AS FRONT-BUILD
COPY ../front-src /app
ENV API_HOST = /
RUN npm run install --registry=https://registry.npm.taobao.org && npm run build


# 阶段2 编译后端
FROM maven:latest AS END-BUILD
COPY ../backend-src /app
COPY --from=FRONT-BUILD /app/build/ /app/src/main/resources/static
CMD mvn jar:jar -Dmvn.skip.test=true


# 构建产物