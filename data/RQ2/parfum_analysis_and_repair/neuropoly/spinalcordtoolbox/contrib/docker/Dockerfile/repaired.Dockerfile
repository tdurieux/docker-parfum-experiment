FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y wget unzip git bzip2 && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/spinalcordtoolbox/spinalcordtoolbox/archive/master.zip
RUN unzip master.zip
WORKDIR spinalcordtoolbox-master
RUN ./install_sct -y
RUN echo "export PATH=/root/sct_dev/bin:$PATH" >>~/.bashrc
