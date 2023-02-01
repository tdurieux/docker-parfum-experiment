FROM ubuntu:bionic

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y sudo \
    && useradd -m cwe \
    && echo "cwe:cwe" | chpasswd \
    && adduser cwe sudo \
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers && rm -rf /var/lib/apt/lists/*;

USER cwe

RUN sudo apt-get install --no-install-recommends python3-pip apt-utils -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip

RUN sudo pip3 install --no-cache-dir scons

ENV PATH="/home/cwe/.local/bin/:${PATH}"

COPY . /home/cwe/artificial_samples/

WORKDIR /home/cwe/artificial_samples/

RUN ./install_cross_compilers.sh