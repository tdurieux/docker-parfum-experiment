FROM ubuntu:latest
ENV VERSION=2.6.1
RUN apt-get --yes update && apt-get --yes dist-upgrade
RUN apt-get --yes --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install keyboard-configuration git && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install coreutils curl xbase-clients xdg-utils firefox libosmesa6 mesa-utils libgl1-mesa-glx openmpi-bin libopenmpi-dev libnexus1 libnexus-dev emacs vim fonts-liberation python3-pip python3-dev jupyter && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.mccode.org/debian/mccode.list > /etc/apt/sources.list.d/mccode.list
RUN apt-get --yes update
RUN apt-get --yes --no-install-recommends install mcstas-suite-python mcstas-suite-perl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mcgui/mcgui.py > /usr/share/mcstas/2.6.1/tools/Python/mcgui/mcgui.py
RUN curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mccodelib/mccode_config.py > /usr/share/mcstas/2.6.1/tools/Python/mccodelib/mccode_config.py
RUN python3 -m pip install McStasScript --upgrade
RUN curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/Docker/mcstas/mcstasscript/mcstasscript-setup.py > /tmp/mcstasscript-setup.py
RUN python3 /tmp/mcstasscript-setup.py
RUN update-alternatives --install /bin/sh sh /bin/bash 200
RUN update-alternatives --install /bin/sh sh /bin/dash 100
RUN groupadd docker
RUN useradd -g docker docker
RUN mkdir /home/mcstasscript && curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/Docker/mcstas/mcstasscript/McStasScript_demo.ipynb > /home/mcstasscript/McStasScript_demo.ipynb
RUN chown -R docker:docker /home/mcstasscript
ENV HOME /home/docker
WORKDIR /home/docker
