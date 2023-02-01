FROM ros:kinetic-ros-base

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    libboost-all-dev \
    libeigen3-dev \
    libflann-dev \
    libqhull-dev \
    libvtk6-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U dlib

RUN apt-get update && apt-get install --no-install-recommends -y curl git wget sudo lsb-release ccache apt-cacher-ng patch man-db && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y mesa-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes -q -qq mongodb-clients mongodb-server -o Dpkg::Options::=--force-confdef && rm -rf /var/lib/apt/lists/*;


RUN addgroup --gid 976 jenkins
RUN adduser --uid 983 --disabled-password --gecos "" --force-badname --ingroup jenkins user

RUN sed -i '/^%sudo/ a user ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

USER user
