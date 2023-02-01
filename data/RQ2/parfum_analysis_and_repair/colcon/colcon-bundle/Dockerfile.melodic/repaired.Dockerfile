FROM ros:melodic

SHELL ["/bin/bash", "-c"]

RUN (apt-get update || true) && apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN curl --fail --show-error --silent --location https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update && \
        apt-get install --no-install-recommends -y wget && \
	wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
        echo "yaml https://s3-us-west-2.amazonaws.com/rosdep/base.yaml" > /etc/ros/rosdep/sources.list.d/19-aws-sdk.list && rm -rf /var/lib/apt/lists/*;

COPY . /opt/package
WORKDIR /opt/package

RUN apt-get update && \
	apt-get install --no-install-recommends -y python3-pip python3-apt python-pip enchant sudo && rm -rf /var/lib/apt/lists/*;

RUN useradd builduser
RUN adduser builduser sudo
RUN mkdir -p /home/builduser
RUN chown builduser /home/builduser
RUN sh -c "echo 'builduser ALL=NOPASSWD: ALL' >> /etc/sudoers"

RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -e .

RUN chown -R builduser /opt/package

USER builduser

RUN	rosdep update && \
	sudo rosdep install --from-paths integration/test_workspace --rosdistro melodic --ignore-src -r -y

WORKDIR /opt/package/integration/test_workspace

# NOTE: This is a workaround for setuptools 50.* (see https://github.com/pypa/setuptools/issues/2352)
ENV SETUPTOOLS_USE_DISTUTILS=stdlib
RUN source /opt/ros/melodic/setup.sh; colcon build
RUN source /opt/ros/melodic/setup.sh; colcon bundle --bundle-version 1 --bundle-base v1 --pip-requirements py27_requirements.txt --pip3-requirements py3_requirements.txt
RUN source /opt/ros/melodic/setup.sh; colcon bundle --bundle-version 2 --bundle-base v2 --pip-requirements py27_requirements.txt --pip3-requirements py3_requirements.txt
