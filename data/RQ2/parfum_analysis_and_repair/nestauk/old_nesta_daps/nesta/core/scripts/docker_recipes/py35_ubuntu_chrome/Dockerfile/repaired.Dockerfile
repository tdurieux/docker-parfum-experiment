FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://gist.githubusercontent.com/ziadoz/3e8ab7e944d02fe872c3454d17af31a5/raw/ff10e54f562c83672f0b1958a144c4b72c070158/install.sh
RUN /bin/bash -c "source install.sh"
RUN sudo apt-get install --no-install-recommends chromium-browser -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir selenium
RUN pip3 install --no-cache-dir pyvirtualdisplay
RUN pip3 install --no-cache-dir awscli --upgrade --user
RUN ~/.local/bin/aws --version

ADD launch.sh /usr/local/bin/launch.sh
WORKDIR /tmp  
USER root     

ENTRYPOINT ["/usr/local/bin/launch.sh"]
