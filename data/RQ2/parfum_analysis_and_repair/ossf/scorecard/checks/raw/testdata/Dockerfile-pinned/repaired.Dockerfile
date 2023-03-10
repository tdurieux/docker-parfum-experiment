# Copyright 2021 Security Scorecard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Note: taken from https://github.com/pushiqiang/utils/blob/master/docker/Dockerfile_template
FROM python:3.7@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2

# 如果在中国，apt使用163源, ifconfig.co/json, http://ip-api.com
RUN curl -f -s ifconfig.co/json | grep "China" > /dev/null && \
    curl -f -s https://mirrors.163.com/.help/sources.list.jessie > /etc/apt/sources.list || true

# 安装开发所需要的一些工具，同时方便在服务器上进行调试
RUN apt-get update; \
    apt-get install --no-install-recommends -y vim; rm -rf /var/lib/apt/lists/*; \
    true

FROM scratch
FROM python@sha256:45b23dee08af5e43a7fea6c4cf9c25ccf269ee113168c19722f87876677c5cb2