FROM ubuntu
MAINTAINER leo.cazenille@gmail.com

RUN \
		DEBIAN_FRONTEND=noninteractive \
		apt-get update && \
		apt-get upgrade -y && \
		apt-get install --no-install-recommends -yq python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash user

USER user
WORKDIR /home/user
RUN pip3 install --no-cache-dir qdpy matplotlib pyyaml scoop
RUN git clone https://gitlab.com/leo.cazenille/qdpy.git
