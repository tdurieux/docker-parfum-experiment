FROM ubuntu:18.04
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN  apt-get update

RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl gnupg2 software-properties-common git && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=arm64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && rm -rf /var/lib/apt/lists/*;
RUN  apt-get update --fix-missing
RUN apt-get -y --no-install-recommends install python-mysqldb build-essential python-dev libmysqlclient-dev python-pip net-tools libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y build-dep python-mysqldb
RUN curl -f -LO "https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    cp kubectl /usr/bin/
RUN mkdir /root/workspace
RUN pip install --no-cache-dir --upgrade pip -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config set install.trusted-host mirrors.aliyun.com
WORKDIR /root/workspace
