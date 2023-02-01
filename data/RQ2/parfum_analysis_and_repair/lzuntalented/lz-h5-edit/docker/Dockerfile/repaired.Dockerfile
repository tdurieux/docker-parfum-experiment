FROM ubuntu
COPY sources.list /etc/apt/sources.list
RUN apt-get update
# 基础包
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
# 设置时区
COPY nginx.install.sh /home/nginx.install.sh
RUN bash /home/nginx.install.sh

RUN apt-get install --no-install-recommends mysql-server -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nginx -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://cdn.npm.taobao.org/dist/node/v14.6.0/node-v14.6.0-linux-x64.tar.xz > /home/node.tar.xz
RUN apt-get install --no-install-recommends xz-utils -y && rm -rf /var/lib/apt/lists/*;
RUN cd /home/ && tar -xvJf node.tar.xz && rm node.tar.xz
# COPY node.sh /home/node.sh
# RUN bash /home/node.sh
RUN echo "export PATH=/home/node-v14.6.0-linux-x64/bin:\$PATH" >> /root/.profile
ENV PATH="/home/node-v14.6.0-linux-x64/bin:${PATH}"

RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && npm cache clean --force;
RUN cnpm i lerna -g
RUN cnpm i pm2 -g

RUN cd /home && git clone https://github.com/lzuntalented/lz-h5-edit.git
RUN mv /home/lz-h5-edit/packages/server /home
RUN cd /home/lz-h5-edit && cnpm run install && cnpm run webpack

COPY mysql.sh /home/mysql.sh
RUN service mysql start && bash /home/mysql.sh
RUN cd /home/server && cnpm i && cnpm run compile
COPY pm2.json /home/server/pm2.json
COPY nginx.default /etc/nginx/sites-available/default
COPY run.sh /home/run.sh
CMD bash /home/run.sh

