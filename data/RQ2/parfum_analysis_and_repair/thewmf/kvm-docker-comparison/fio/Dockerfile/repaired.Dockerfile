# in production this should probably be busybox, but let's use ubuntu for a
# fair comparison
FROM tutum/ubuntu-saucy

MAINTAINER Wes Felter, wmf@us.ibm.com

RUN apt-get -qq --no-install-recommends install -y fio && rm -rf /var/lib/apt/lists/*;

ADD test.fio /

VOLUME ["/ferrari"]
ENTRYPOINT ["fio"]
# CMD [] works around a bug in old versions of Docker
CMD []
