FROM ros:galactic

CMD ["/bin/bash"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --no-install-recommends -q -y curl gnupg2 lsb-release build-essential cmake && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -q -y python3-colcon-core python3-colcon-common-extensions && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -q -y libeigen3-dev && rm -rf /var/lib/apt/lists/*;