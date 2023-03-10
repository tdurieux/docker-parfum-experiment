FROM robocupssl/ubuntu-vnc:latest

USER root

# setup apt tools and other goodies we want
RUN apt-get update --fix-missing && \
    apt-get -y --no-install-recommends install udev locales git ssh software-properties-common \
        sudo tzdata keyboard-configuration lsb-release ca-certificates apt-transport-https \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;

# Prevent bugging us later about timezones
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Use UTF-8
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

COPY --chown=default . /robocup-software
WORKDIR /robocup-software

RUN SUDO_USER=default ./util/ubuntu-setup --yes --no-submodules

USER default
