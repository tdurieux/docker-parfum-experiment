# SPDX-FileCopyrightText: 2020-2021 CASTOR Software Research Centre
# <https://www.castor.kth.se/>
# SPDX-FileCopyrightText: 2020-2021 Johan Paulsson

# SPDX-License-Identifier: Apache-2.0

#This dockerfile represents a single node/client in a network.
#It uses the example from https://github.com/p4lang/ptf/ptf_nn
#to listen and forward packages

FROM ubuntu:18.04

# Packages
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tcpdump && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnanomsg-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir rpyc
RUN pip3 install --no-cache-dir netifaces
RUN pip3 install --no-cache-dir nnpy
RUN git clone https://github.com/p4lang/ptf /usr/local/src/ptf
RUN cd /usr/local/src/ptf && pip3 install --no-cache-dir .

CMD tail -f /dev/null
