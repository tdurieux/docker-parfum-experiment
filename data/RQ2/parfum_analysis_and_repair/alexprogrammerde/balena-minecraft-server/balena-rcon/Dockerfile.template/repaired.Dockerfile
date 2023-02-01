FROM balenalib/%%BALENA_MACHINE_NAME%%-debian:latest

RUN install_packages make git gcc build-essential

RUN cd /usr/src/ \
    && git clone https://github.com/Tiiffi/mcrcon.git \
    && cd mcrcon \
    && make \
    && make install

COPY . /usr/src/

COPY .bashrc /root/

CMD [ "balena-idle" ]