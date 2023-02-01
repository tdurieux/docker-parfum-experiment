# os
FROM ubuntu:16.04

# apt
RUN apt-get -y update \
	&& apt-get install --no-install-recommends -y software-properties-common \
	&& apt-get -y update \
	&& apt-get install --no-install-recommends -y git python-pip python3-pip && rm -rf /var/lib/apt/lists/*;

# pip
RUN git clone https://github.com/matthewgadd/RobotCarDataset-Scraper.git \
    && cd RobotCarDataset-Scraper \
    && pip3 install --no-cache-dir -r requirements.txt

# alias
RUN echo 'alias python=python3' >> /root/.bashrc \
	&& echo 'alias pip=pip3' >> /root/.bashrc

# entry point at a working dir
ENTRYPOINT ["/bin/bash"]