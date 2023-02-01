# SPDX-FileCopyrightText: 2020-2021 CASTOR Software Research Centre
# <https://www.castor.kth.se/>
# SPDX-FileCopyrightText: 2020-2021 Johan Paulsson

# SPDX-License-Identifier: Apache-2.0

#This dockerfile defines the container responisble for executing the tests.
#It uses the ptf test framework to do so

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libnanomsg-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir nnpy
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir scapy

#PTF install
RUN git clone https://github.com/p4lang/ptf /usr/local/src/ptf

RUN cd /usr/local/src/ptf && pip3 install --no-cache-dir .

CMD tail -f /dev/null


