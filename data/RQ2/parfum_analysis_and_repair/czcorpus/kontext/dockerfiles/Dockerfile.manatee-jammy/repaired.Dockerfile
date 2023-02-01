# This dockerfile produces the image czcorpus/kontext-manatee:2.208-jammy
FROM ubuntu:jammy

RUN apt-get update && apt-get install --no-install-recommends -y swig libpcre++ locales python3 python3-dev wget build-essential libltdl-dev libpcre3-dev && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales
# for some reason, the installation of Manatee produces incorrect target path /usr/local/local/lib/...
RUN rm -rf /usr/local/local/lib/python3.10/dist-packages/__pycache__
RUN mv /usr/local/local/lib/python3.10/dist-packages/* /usr/local/lib/python3.10/dist-packages/

WORKDIR /opt/kontext

COPY ./scripts/install/steps.py ./scripts/install/*.patch ./scripts/install/
RUN python3 scripts/install/steps.py SetupManatee --step-args 2.208 scripts/install/ucnk-manatee-2.208.patch 0
RUN rm -r /usr/local/src/manatee-open-2.208
