FROM i386/ubuntu:18.04

ENV USERNAME=ezpwn

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;

RUN useradd -s /usr/sbin/nologin -m ${USERNAME}

COPY ./flag.txt /home/${USERNAME}/
COPY ./ezpwn.conf /etc/xinetd.d/ezpwn
COPY ./ezpwn /home/${USERNAME}/

RUN chown -R root:${USERNAME} /home/${USERNAME} && \
    chmod -R 750 /home/${USERNAME}

EXPOSE 5000
CMD ["/usr/sbin/xinetd", "-d"]