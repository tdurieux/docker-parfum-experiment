# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#
# Copyright (c) Peking University 2018
#
# The software is released under the Open-Intelligence Open Source License V1.0.
# The copyright owner promises to follow "Open-Intelligence Open Source Platform
# Management Regulation V1.0", which is provided by The New Generation of 
# Artificial Intelligence Technology Innovation Strategic Alliance (the AITISA).

FROM {{ clusterconfig['clusterinfo']['dockerregistryinfo']['docker_namespace'] }}/base-image

RUN apt-get -y install zookeeper

ENV PATH $PATH:/usr/share/zookeeper/bin

RUN mkdir -p /var/lib/zoodata
COPY zoo.cfg /etc/zookeeper/conf/
COPY myid /

# Use sed to modify Zookeeper env variable to also log to the console
RUN sed -i '/^ZOO_LOG4J_PROP/ s:.*:ZOO_LOG4J_PROP="INFO,CONSOLE":' /usr/share/zookeeper/bin/zkEnv.sh

COPY run.sh /usr/local/run.sh
RUN chmod a+x /usr/local/run.sh

CMD ["/usr/local/run.sh"]
