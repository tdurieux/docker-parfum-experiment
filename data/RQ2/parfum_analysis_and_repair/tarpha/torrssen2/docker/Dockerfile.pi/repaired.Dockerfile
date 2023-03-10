FROM tarpha/ubuntu:openjdk-8-pi
ENV  LC_ALL=C.UTF-8
COPY run_pi.sh /run.sh
COPY kill.sh /kill.sh
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/tarpha/torrssen2.git
VOLUME [ "/root/data" ]
EXPOSE 8080
ENTRYPOINT ["/run.sh"]