FROM ubuntu

ARG CATBLOCKSREPO="Catrobat/Catblocks"
ARG CATROIDREPO="https://github.com/Catrobat/Catroid.git"
ARG WORKDIR="/checker/"

# install required packages
RUN apt update
RUN apt install -y --no-install-recommends python3 python3-pip --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends build-essential --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends git --assume-yes && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends curl --assume-yes && rm -rf /var/lib/apt/lists/*;

# install required python packages
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir python-dateutil
RUN pip3 install --no-cache-dir gitpython
RUN pip3 install --no-cache-dir jsonnet

# remove cache
RUN rm -rf /var/cache/apk/* /tmp/*

ENV CATBLOCKS=${CATBLOCKSREPO}
ENV CATROID=${CATROIDREPO}
ENV WORKDIR=${WORKDIR}

# copy python script to docker
COPY require/checker.py /checker.py

# cmd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
