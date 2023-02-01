FROM ubuntu:latest
ENV VERSION=2.6.1
RUN apt-get --yes update && apt-get --yes dist-upgrade
RUN apt-get --yes --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install coreutils curl xbase-clients xdg-utils firefox libosmesa6 mesa-utils libgl1-mesa-glx openmpi-bin libopenmpi-dev emacs vim fonts-liberation && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.mccode.org/debian/mccode.list > /etc/apt/sources.list.d/mccode.list
RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install mcstas-suite-python && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mcgui/mcgui.py > /usr/share/mcstas/2.6.1/tools/Python/mcgui/mcgui.py
RUN curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mccodelib/mccode_config.py > /usr/share/mcstas/2.6.1/tools/Python/mccodelib/mccode_config.py
RUN update-alternatives --install /bin/sh sh /bin/bash 200
RUN update-alternatives --install /bin/sh sh /bin/dash 100
RUN groupadd docker
RUN useradd -g docker docker
ENV HOME /home/docker
WORKDIR /home/docker
