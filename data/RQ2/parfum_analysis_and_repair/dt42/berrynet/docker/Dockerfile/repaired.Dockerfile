# We start from Debian Buster. Can be rebase to Raspbian because they are
# similar
FROM debian:buster
LABEL maintainer="dev@dt42.io"
LABEL project="Berrynet"
LABEL version="3.7.0"

# Update apt
RUN apt-get update

# Install dependencies
RUN apt-get install --no-install-recommends -y git sudo wget lsb-release software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install build-essential
RUN apt-get install --no-install-recommends -y build-essential curl && rm -rf /var/lib/apt/lists/*;

# Install systemd
RUN apt-get install --no-install-recommends -y systemd systemd-sysv && rm -rf /var/lib/apt/lists/*;

# Install python
RUN apt-get install --no-install-recommends -y python3 python3-dev && rm -rf /var/lib/apt/lists/*;

# Install python libs
RUN apt-get install --no-install-recommends -y python3-wheel python3-setuptools python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-paho-mqtt python3-logzero python3-astor && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-opengl python3-six python3-grpcio && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-keras-applications python3-keras-preprocessing && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-protobuf python3-termcolor python3-numpy && rm -rf /var/lib/apt/lists/*;

# Install daemons
RUN apt-get install --no-install-recommends -y mosquitto mosquitto-clients && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;

# Install tensorflow
RUN pip3 install --no-cache-dir tensorflow

# Install BerryNet
RUN git clone https://github.com/DT42/BerryNet.git
RUN cd BerryNet; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
