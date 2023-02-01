FROM ubuntu:18.04
# if using proxy please uncomment and edit proxy config below
#ENV http_proxy <http_proxy:port>
#ENV https_proxy <https_proxy:port>

ENV LANG en_US.UTF-8
RUN rm -rf /etc/apt/sources.list.d/ubuntu-esm-infra-trusty.list
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y sudo software-properties-common locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

ARG USERNAME
ARG USERID
RUN adduser --disabled-password --uid ${USERID} --gecos '' ${USERNAME} \
    && adduser ${USERNAME} sudo                        \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# set up volumes
VOLUME /scripts
VOLUME /workdir


# USER root
RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends -y software-properties-common curl git wget build-essential autotools-dev automake gawk zlib1g-dev libtool libaio-dev libaio1 pandoc pkgconf libcap-dev && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --no-install-recommends -y python3.7 python3.7-dev python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;
RUN wget https://golang.org/dl/go1.13.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.13.4.linux-amd64.tar.gz && rm go1.13.4.linux-amd64.tar.gz
ENV PATH="$PATH:/usr/local/go/bin"
RUN wget https://storage.googleapis.com/shellcheck/shellcheck-v0.7.0.linux.x86_64.tar.xz
RUN tar -xf shellcheck-v0.7.0.linux.x86_64.tar.xz && rm shellcheck-v0.7.0.linux.x86_64.tar.xz
RUN cp shellcheck-v0.7.0/shellcheck /usr/bin/
RUN go get github.com/mrtazz/checkmake
ENV BUILDER_NAME="builder"
ENV BUILDER_EMAIL="builder@company.com"
RUN cd /root/go/src/github.com/mrtazz/checkmake && make && cp checkmake /usr/local/bin/
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7
RUN rm -rf /usr/lib/python3/dist-packages/yaml
RUN rm -rf /usr/lib/python3/dist-packages/PyYAML-*
RUN pip3 install --no-cache-dir PyYaml >=5.1.2
RUN pip3 install --no-cache-dir pandas
RUN pip3 install --no-cache-dir pyinstaller==4.5.1
RUN pip3 install --no-cache-dir black
RUN pip3 install --no-cache-dir bandit
RUN pip3 install --no-cache-dir flake8
RUN pip3 install --no-cache-dir mypy
RUN pip3 install --no-cache-dir pytype
RUN pip3 install --no-cache-dir pytest
RUN pip3 install --no-cache-dir xlsxwriter
RUN pip3 install --no-cache-dir python-dateutil
RUN pip3 install --no-cache-dir --upgrade 'setuptools<45.0.0'
RUN apt-get update && apt-get install --no-install-recommends -y linux-tools-generic && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/markbates/pkger/cmd/pkger
RUN cd /root/go/bin && cp pkger /usr/local/bin/
ENV GOCACHE=/tmp
ENV GOPATH=/tmp

# Run container as non-root user from here onwards
# so that build output files have the correct owner
USER ${USERNAME}

# run bash script and process the input command
ENTRYPOINT [ "/bin/bash", "/scripts/entrypoint"]
