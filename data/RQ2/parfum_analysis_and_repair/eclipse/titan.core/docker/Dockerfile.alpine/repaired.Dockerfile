FROM alpine:edge

## INSTALL DEPENDENCIES
RUN apk update && \
    apk add --no-cache sudo make git g++ diffutils expect openssl-dev libxml2-dev libxml2-utils ncurses-dev flex bison perl libexecinfo-dev bash libedit libedit-dev lksctp-tools lksctp-tools-dev 

## CREATE SUDOER USER
RUN adduser -S -D -G root -h /home/titan -s /bin/bash titan && \
    echo "titan:titan" | chpasswd && \
    echo "titan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER titan

## SETUP .BASHRC TO SETUP HOSTS FILE AT THE BOOT TIME
RUN echo 'sudo sh -c "cp /etc/hosts /etc/append && (echo \"127.0.1.1  $HOSTNAME\"; cat /etc/append) > /etc/hosts"' >> /home/titan/.bashrc
RUN echo 'sh' >> /home/titan/.bashrc

## CLONE TITAN
WORKDIR /home/titan
RUN git clone https://github.com/eclipse/titan.core.git
WORKDIR /home/titan/titan.core/
RUN git checkout tags/7.2.1_final

## SET UP ENV VARIABLES
ENV TTCN3_DIR=/home/titan/titan.core/Install
ENV PATH=$TTCN3_DIR/bin:$PATH \
    LD_LIBRARY_PATH=$TTCN3_DIR/lib:$LD_LIBRARY_PATH

## SET FLAGS
#RUN echo 'ALPINE_LINUX := yes \n\
#          TTCN3_DIR := /home/titan/titan.core/Install \n\
#          XMLDIR := /usr \n\
#          OPENSSL_DIR := /usr \n\
#          JNI := no \n\
#          GEN_PDF := no' >> Makefile.personal
COPY Makefile.personal-alpine Makefile.personal

## BUILD TITAN
RUN make install

ENTRYPOINT /bin/bash