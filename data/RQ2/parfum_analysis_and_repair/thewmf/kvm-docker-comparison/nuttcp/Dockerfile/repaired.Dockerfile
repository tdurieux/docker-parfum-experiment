# in production this should probably be busybox, but let's use ubuntu for a
# fair comparison
FROM tutum/ubuntu-saucy

MAINTAINER Wes Felter, wmf@us.ibm.com

RUN apt-get install --no-install-recommends -y nuttcp && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000
EXPOSE 5001

ENTRYPOINT ["nuttcp"]
# CMD [] works around a bug in old versions of Docker
CMD []
