FROM fullaxx/ubuntu-desktop:xfce4
ENV VERSION=3.0
RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install coreutils curl xbase-clients xdg-utils firefox libosmesa6 mesa-utils libgl1-mesa-glx openmpi-bin libopenmpi-dev emacs vim fonts-liberation && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.mccode.org/debian/mccode.list > /etc/apt/sources.list.d/mccode.list
RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install mcstas-suite-python && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install mcstas-suite-python-ng && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install mcxtrace-suite-python && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install libnexus-dev libnexus1 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /bin/sh sh /bin/bash 200
RUN update-alternatives --install /bin/sh sh /bin/dash 100
RUN groupadd docker
RUN useradd -g docker docker
WORKDIR /home/docker
