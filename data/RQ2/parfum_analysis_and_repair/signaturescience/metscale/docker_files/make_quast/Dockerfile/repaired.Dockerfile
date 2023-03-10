#This Dockerfile is for QUAST-4.0
FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y g++ make wget python python-matplotlib zlib1g-dev cmake openjdk-6-jdk curl libboost-all-dev libncurses5-dev git python-setuptools && rm -rf /var/lib/apt/lists/*; # Dependencies


#Clone the quast git repo and build it
RUN git clone https://github.com/ablab/quast.git /home/quast
RUN cd /home/quast && python setup.py install_full
CMD /mydata/do-quast.sh
