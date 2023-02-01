FROM ubuntu:latest
MAINTAINER Jean Rabault (jean.rblt@gmail.com)

RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends apt-utils -y && \
    apt-get install --no-install-recommends git -y && \
    apt-get install --no-install-recommends qrencode -y && \
    apt-get install --no-install-recommends coreutils -y && \
    apt-get install --no-install-recommends zbar-tools -y && \
    apt-get install --no-install-recommends gzip -y && \
    apt-get install --no-install-recommends imagemagick -y && \
    apt-get install --no-install-recommends img2pdf -y && \
    apt-get install --no-install-recommends par2 -y && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir Git

RUN cd Git && git clone https://github.com/jerabaul29/qrdump.git

CMD cd Git/qrdump/src && bash qrdump.sh --version
