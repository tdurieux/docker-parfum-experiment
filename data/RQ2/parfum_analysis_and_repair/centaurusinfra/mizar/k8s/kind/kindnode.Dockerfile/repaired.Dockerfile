# SPDX-License-Identifier: MIT
# Copyright (c) 2020 The Authors.

# Authors: Sherif Abdelwahab <@zasherif>
#          Phu Tran          <@phudtran>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:The above copyright
# notice and this permission notice shall be included in all copies or
# substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS",
# WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
# THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FROM kindest/node:v1.18.2
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rpcbind && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsyslog && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libelf-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ethtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir PyYAML
RUN pip3 install --no-cache-dir kopf
RUN pip3 install --no-cache-dir netaddr
RUN pip3 install --no-cache-dir ipaddress
RUN pip3 install --no-cache-dir pyroute2
RUN pip3 install --no-cache-dir rpyc
RUN pip3 install --no-cache-dir kubernetes==11.0.0
RUN pip3 install --no-cache-dir luigi==2.8.12
RUN pip3 install --no-cache-dir grpcio
RUN pip3 install --no-cache-dir protobuf
RUN pip3 install --no-cache-dir fs
RUN mkdir -p /var/mizar/
RUN mkdir -p /opt/cni/bin
RUN mkdir -p /etc/cni/net.d
RUN ln -snf /sys/fs/bpf /bpffs
