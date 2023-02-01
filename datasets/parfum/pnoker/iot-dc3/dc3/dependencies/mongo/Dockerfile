#
# Copyright (c) 2022. Pnoker. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM registry.cn-beijing.aliyuncs.com/dc3/mongo:5.0.5
MAINTAINER pnoker <pnokers.icloud.com>

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir -p /dc3-mongo/config/

WORKDIR /dc3-mongo

COPY ./iot-dc3.js  ./config/
COPY ./launch.sh   ./

RUN apt update \
    && apt install tofrodos \
    && apt clean \
    && fromdos ./launch.sh \
    && chmod +x ./launch.sh

EXPOSE 27017

CMD [ "/dc3-mongo/launch.sh"]