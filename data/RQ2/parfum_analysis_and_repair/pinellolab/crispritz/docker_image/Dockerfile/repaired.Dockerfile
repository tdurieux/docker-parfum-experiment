#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu Software repository
RUN apt-get update

# Upgrade Ubuntu Software repository
RUN apt-get upgrade -y

# Install all required libraries and packages
RUN apt-get install --no-install-recommends g++-5 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-all-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends bcftools -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-tk -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;

# Set case-insesitive bash
RUN echo set completion-ignore-case on | tee -a /etc/inputrc

# Set g++-5 default g++ and python3 default python
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.5 50

# Pip libraries for python
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir intervaltree
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir more-itertools
RUN pip install --no-cache-dir ecdf
RUN pip install --no-cache-dir statsmodels

# Prepare CRISPRitz to be tested and used
RUN wget https://github.com/InfOmics/CRISPRitz/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv CRISPRitz-master/ CRISPRitz
#RUN bash CRISPRitz/download_test_files.sh
RUN mv CRISPRitz/ root/
#RUN mv chr22_* root/CRISPRitz/
RUN rm root/CRISPRitz/download_test_files.sh root/CRISPRitz/README.md
RUN chmod -R 700 root/CRISPRitz/*
RUN make -f root/CRISPRitz/docker_image/Makefile_docker
RUN mv root/CRISPRitz/docker_image/crispritz.py buildTST searchBruteForce searchTST /usr/bin/
RUN cp -R root/CRISPRitz/sourceCode/Python_Scripts/ /usr/bin/
#RUN rm root/CRISPRitz/Makefile root/CRISPRitz/meta.yaml root/CRISPRitz/build.sh root/CRISPRitz/LICENSE root/CRISPRitz/Dockerfile root/CRISPRitz/crispritz.py
#RUN rm -rf root/CRISPRitz/docker_image
#RUN rm -rf root/CRISPRitz/sourceCode
RUN rm -rf root/CRISPRitz

# Set workdir
WORKDIR root/CRISPRitz

# Set expose to port 80 and 443
EXPOSE 80 443


