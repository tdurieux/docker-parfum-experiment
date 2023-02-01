FROM ros:melodic-ros-base-bionic

ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# install ros packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-melodic-robot=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

# SYSTEM DEPENDENCIES
#----------------------------------------------------------
RUN echo "regen"
RUN export DEBIAN_FRONTEND="noninteractive"; apt-get update && apt-get install --no-install-recommends -y apt-utils && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packagecloud.io/install/repositories/reelrbtx/SMACC/script.deb.sh | sudo bash
RUN apt-get install --no-install-recommends -y ros-melodic-smacc ros-melodic-sm-dance-bot-strikes-back ros-melodic-sm-atomic && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://b0e12e65a4f16bfc4594206c69dce2a49a5eabd04efb7540:@packagecloud.io/install/repositories/reelrbtx/SMACC_viewer/script.deb.sh | bash
RUN apt-get -y --no-install-recommends install ros-melodic-smacc-viewer && rm -rf /var/lib/apt/lists/*;

WORKDIR /root