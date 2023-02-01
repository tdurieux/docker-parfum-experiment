FROM ubuntu:18.04
MAINTAINER lsc

# 编译构建开发工具
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y fontconfig --fix-missing -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gdb -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends cmake -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

# mysql&redis的中间件  mysql-server redis-server
RUN apt-get install --no-install-recommends mysql-server -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends redis -y && rm -rf /var/lib/apt/lists/*;

# libevent&redis&mysql的头文件以及动态库
RUN apt-get install --no-install-recommends libmysqlclient-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libevent-dev -y && rm -rf /var/lib/apt/lists/*;


# 1、redis的api和so
# RUN wget https://github.com/redis/hiredis/archive/refs/tags/v1.0.2.tar.gz
# RUN tar -zxvf v1.0.2.tar.gz
# RUN cd hiredis-1.0.2
# RUN make
# RUN make

RUN mkdir /opt/app
COPY . /opt/app/
WORKDIR /opt/app
RUN cp libhiredis.so /usr/local/lib
RUN cp -r ./hiredis  /usr/local/include/hiredis
RUN echo '/usr/local/lib' >>/etc/ld.so.conf
RUN ldconfig


# 2、git下载不了代码  ssh的私钥配置的有问题  git clone dsf的代码
# WORKDIR /tmp
# COPY id_rsa .
# RUN git clone git@gitee.com:lexingsen/dsf-lsc.git