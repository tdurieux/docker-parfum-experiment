FROM ros:melodic-ros-core

SHELL ["/bin/bash", "-c"]

RUN useradd --create-home --shell /bin/bash spaceuser \
    && mkdir -p /home/spaceuser/Programming/robotics-prototype

WORKDIR /home/spaceuser/Programming/robotics-prototype
COPY requirements.txt setup.py ./

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip \
    && pip3 install --no-cache-dir -r requirements.txt \
    && python3 setup.py develop && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-cv-camera \
    && apt-get install --no-install-recommends -y ros-$ROS_DISTRO-web-video-server && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN chown -R spaceuser:spaceuser /home/spaceuser/Programming/robotics-prototype \
    && echo "source /opt/ros/melodic/setup.bash" >> /home/spaceuser/.bashrc

USER spaceuser
RUN chmod u+x ./docker/prototype/entrypoint.sh
ENTRYPOINT ["./docker/prototype/entrypoint.sh"]
