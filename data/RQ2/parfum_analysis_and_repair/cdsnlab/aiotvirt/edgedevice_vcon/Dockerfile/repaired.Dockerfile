# dockerfile for container.
# input and output data?
#   - input: read redis values
#   - ouput: ???.

FROM python:3.6

# install libs.
RUN apt-get update \ 
	&& apt-get upgrade -y \
	&& apt-get install --no-install-recommends -y \
	build-essential sudo udev usbutils wget \
	&& apt-get clean all && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir psutil
RUN sudo pip3 install --no-cache-dir redis
RUN sudo pip3 install --no-cache-dir paho-mqtt

ADD . /vcontainer
WORKDIR /vcontainer


CMD ["python3", "tracking.py"]
