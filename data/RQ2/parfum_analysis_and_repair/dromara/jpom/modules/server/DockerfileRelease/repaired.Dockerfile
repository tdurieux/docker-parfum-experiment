#
# The MIT License (MIT)
#
# Copyright (c) 2019 Code Technology Studio
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

FROM maven:3.8.5-jdk-8

ENV JPOM_HOME	/usr/local/jpom-server
ENV JPOM_PKG	server-2.9.4-release.tar.gz

ENV JPOM_DATA_PATH ${JPOM_HOME}/data
ENV JPOM_LOG_PATH ${JPOM_HOME}/log
# 数据目录
ENV jpom.path ${JPOM_DATA_PATH}

WORKDIR ${JPOM_HOME}

# 时区
ENV TZ Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN mkdir -p ${JPOM_HOME} && \
    curl -LfSo ${JPOM_HOME}/${JPOM_PKG} https://jpom-releases.oss-cn-hangzhou.aliyuncs.com/${JPOM_PKG} && \
    tar -zxvf ${JPOM_HOME}/${JPOM_PKG} -C ${JPOM_HOME} && \
    rm -rf ${JPOM_HOME}/${JPOM_PKG}

# 健康检查
HEALTHCHECK CMD [ curl -X POST -f https://localhost:2122/check-system || exit 1]

EXPOSE 2122

ENTRYPOINT ["/bin/bash", "Server.sh", "start"]



