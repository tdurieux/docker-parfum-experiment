FROM ros:kinetic

RUN apt update
RUN apt install --no-install-recommends -y curl software-properties-common apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt update
RUN apt install --no-install-recommends -y python-pip python-catkin-tools docker-ce && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ros workspace
RUN mkdir -p /ws/src/dockeros
COPY . /ws/src/dockeros
WORKDIR /ws/src
RUN /ros_entrypoint.sh catkin_init_workspace
WORKDIR /ws
RUN /ros_entrypoint.sh catkin build
COPY tests/ros_entrypoint.sh /
RUN chmod 777 /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
