FROM opensuse/leap:latest
RUN zypper -n update 
RUN zypper -n install git wget curl vim which python3 
COPY sofaroot/tools/prepare.sh prepare.sh 
RUN ./prepare.sh
COPY sofaroot /sofaroot