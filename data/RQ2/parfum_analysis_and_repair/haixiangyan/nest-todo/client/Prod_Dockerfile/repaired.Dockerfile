# 使用 node 镜像
FROM node as builder

# 准备工作目录
RUN mkdir -p /app/client
WORKDIR /app/client

# 复制 package.json
COPY package*.json /app/client/

# 安装目录
RUN npm install && npm cache clean --force;

# 复制文件
COPY . /app/client/

# 构建
RUN npm run build

# 准备 nginx
FROM nginx

# 自定义 nginx 设置文件
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

# 从 React container 里复制构建出来的文件
COPY --from=builder /app/client/build /usr/share/nginx/html

# 添加运行权限
RUN chown nginx.nginx /usr/share/nginx/html/ -R

# 暴露端口
EXPOSE 80
