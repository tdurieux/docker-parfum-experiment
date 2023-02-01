# Base image
FROM ros:melodic

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Basic tools
RUN apt-get update && \
    apt-get install --no-install-recommends vim nano git tmux wget curl python-pip net-tools iputils-ping -y && rm -rf /var/lib/apt/lists/*;

# Install additional ros packages
RUN apt-get update && apt-get install --no-install-recommends ros-melodic-rosbridge-server ros-melodic-joy -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir adafruit-pca9685


# Install packages for web application
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN npm install http-server -g && npm cache clean --force;

# Install packages for camera use
RUN apt-get update && \
    apt-get install --no-install-recommends ros-melodic-web-video-server ros-melodic-usb-cam -y && rm -rf /var/lib/apt/lists/*;

# Add ros sourcing to bashrc
RUN echo ". /opt/ros/melodic/setup.bash" >> ~/.bashrc

# Create Ros workspace
ENV EXOMY_WS=/root/exomy_ws
RUN mkdir -p $EXOMY_WS/src

WORKDIR /root

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
