from debian:buster

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git wget unzip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade git+https://github.com/Gallopsled/pwntools@dev