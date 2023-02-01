FROM python:3.8-buster

RUN pip3 install --no-cache-dir ansible
RUN apt update && apt install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

# RUN useradd -ms /bin/bash dockeruser
# RUN usermod -aG sudo dockeruser
RUN adduser --disabled-password --gecos '' dockeruser
RUN adduser dockeruser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER dockeruser
RUN mkdir /home/dockeruser/ansible
WORKDIR /home/dockeruser
