FROM ubuntu:jammy

MAINTAINER ops@mudita.com
# Docker runner for MuditaOS builds

RUN ln -fs /usr/share/zoneinfo/@DOCKER_TIMEZONE@ /etc/localtime
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get full-upgrade -y
RUN apt-get install --no-install-recommends -y \
        @INSTALL_PACKAGES@ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qy autoremove
RUN apt-get -qy clean
RUN ln -fs /usr/bin/python3 /usr/bin/python
RUN locale-gen pl_PL.UTF-8 \
               en_US.UTF-8 \
               de_DE.UTF-8 \
               es_ES.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive tzdata
RUN mkdir -p /home/runner/app/settings

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 1000 --slave /usr/bin/g++ g++ /usr/bin/g++-10

RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt-get update
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

#add python packages
ADD assets/requirements.txt /home/docker/requirements.txt
RUN pip3 install --no-cache-dir -r /home/docker/requirements.txt

# ARM compiler
ADD assets/@ARM_GCC_PKG@ /usr/local/

# CMake
ADD assets/@CMAKE_PKG@ /usr/local/

ENV CMAKE_NAME="/usr/local/@CMAKE_NAME@"
ENV ARM_GCC="/usr/local/@ARM_GCC@"

ENV PATH="/user/local/actions-runner:/usr/local/@CMAKE_NAME@/bin:/usr/local/@ARM_GCC@/bin:$PATH"
ENV TERM="xterm-256color"

ADD assets/.bashrc /home/docker/

COPY assets/cmd.sh /cmd.sh
COPY assets/entrypoint.sh /entrypoint.sh
COPY ci_actions.sh /ci_actions.sh

RUN echo "export PATH="/user/local/actions-runner:/usr/local/@CMAKE_NAME@/bin:/usr/local/@ARM_GCC@/bin:$PATH"" > /etc/profile.d/setup_path.sh
RUN chmod +x /etc/profile.d/setup_path.sh
RUN chmod +x /cmd.sh && \
    chmod +x /entrypoint.sh && \
    groupadd -r runner && \
    useradd --no-log-init -r -g runner runner && \
    chown -R runner:runner /home/runner

WORKDIR /home/runner/app

USER runner

ENTRYPOINT ["/@ENTRYPOINT@"]

