# Docker image of disconf mysql
# VERSION 0.0.1
# Author: bolingcavalry

#基础镜像使用daocloud.io/library/mysql:8
FROM daocloud.io/library/mysql:8

#作者
MAINTAINER BolingCavalry <zq2599@gmail.com>

#定义工作目录
ENV WORK_PATH /usr/local/work

#定义会被容器自动执行的目录
ENV AUTO_RUN_DIR /docker-entrypoint-initdb.d

#定义sql文件名
ENV FILE_0 0-init_table.sql
ENV FILE_1 1-init_data.sql
ENV FILE_2 20151225.sql
ENV FILE_3 20160701.sql

#定义shell文件名
ENV INSTALL_DATA_SHELL install_data.sh

#创建文件夹
RUN mkdir -p $WORK_PATH

#把数据库初始化数据的文件复制到工作目录下
COPY ./$FILE_0 $WORK_PATH/
COPY ./$FILE_1 $WORK_PATH/
COPY ./$FILE_2 $WORK_PATH/
COPY ./$FILE_3 $WORK_PATH/

#把要执行的shell文件放到/docker-entrypoint-initdb.d/目录下，容器会自动执行这个shell
COPY ./$INSTALL_DATA_SHELL $AUTO_RUN_DIR/

#给执行文件增加可执行权限
RUN chmod a+x $AUTO_RUN_DIR/$INSTALL_DATA_SHELL
