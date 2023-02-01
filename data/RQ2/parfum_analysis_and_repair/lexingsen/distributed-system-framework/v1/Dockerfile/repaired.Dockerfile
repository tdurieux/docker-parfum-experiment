FROM ubuntu:18.04
MAINTAINER lsc
# 安装libevent mysql openssl(md5) json 运行时动态库 主要是.so和头文件

COPY sources.list /etc/apt
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y fontconfig --fix-missing -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libevent-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libjsoncpp-dev -y && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/include/jsoncpp/json/ /usr/include/json
RUN apt-get install --no-install-recommends libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends mysql-server -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
# RUN git clone https://github.com/lexingsen/distributed-system-framework.git
RUN apt-get install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gdb -y && rm -rf /var/lib/apt/lists/*;
