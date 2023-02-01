FROM ubuntu:17.10
USER root
RUN apt-get update && apt-get install -y rinetd curl libcurl3-gnutls
RUN echo "0.0.0.0 10271 10.100.0.1 10271" >> /etc/rinetd.conf
RUN echo "0.0.0.0 8923 10.100.0.1 8923" >> /etc/rinetd.conf
RUN echo "0.0.0.0 8232 10.100.0.1 8232" >> /etc/rinetd.conf
RUN useradd -u 111 jenkins
USER jenkins
WORKDIR /usr/mm/etomic_build/seed
CMD /usr/sbin/rinetd && rm -rf DB && ./run
