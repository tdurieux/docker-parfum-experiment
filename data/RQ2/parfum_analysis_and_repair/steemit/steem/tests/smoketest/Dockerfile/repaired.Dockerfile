FROM phusion/baseimage:0.9.19

ENV LANG=en_US.UTF-8
ENV WDIR=/usr/local/steem
ENV SMOKETEST=$WDIR/smoketest

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cpio && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pyresttest

COPY . $WDIR/

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#reference: volume points to reference steemd
#tested: volume points to tested steemd
#ref_blockchain: volume points to reference folder, where blockchain folder exists
#tested_blockchain: volume points to tested folder, where blockchain folder exists
#logs_dir: location where non-empty logs will be copied
VOLUME ["reference", "tested", "ref_blockchain", "tested_blockchain", "logs_dir", "run"]

EXPOSE 8090
EXPOSE 8091

#CMD pyresttest
CMD cd $SMOKETEST && \
   ./smoketest.sh /reference/steemd /tested/steemd /ref_blockchain /tested_blockchain $STOP_AT_BLOCK $JOBS $COPY_CONFIG 2>&1 | tee log.txt || \
   find ./ -type f -path */logs/* -not -name logs | cpio -pd /logs_dir && \
   cp log.txt /logs_dir && \
   chmod -R a+rw /logs_dir
