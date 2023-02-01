FROM debian:stable
MAINTAINER Pierre Mavro <deimos@deimos.fr>

##################
# User Quick Try #
##################

RUN echo 'deb http://mysecureshell.free.fr/repository/index.php/debian/7.1 testing main' \
> /etc/apt/sources.list.d/mysecureshell.list
RUN echo 'deb-src http://mysecureshell.free.fr/repository/index.php/debian/7.1 testing main' \
>> /etc/apt/sources.list.d/mysecureshell.list
RUN gpg --batch --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys E328F22B
RUN gpg --batch --export E328F22B | apt-key add -
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y -o Dpkg::Options::="--force-confdef" \
 -o Dpkg::Options::="--force-confold" install mysecureshell whois procps openssh-s install mysecureshell whois procps openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN mkdir /var/run/sshd
RUN pass=$(mkpasswd -m sha-512 -s mssuser) && useradd -m -s /usr/bin/mysecureshell -p $pass mssuser
RUN echo 'root:root' | chpasswd
RUN chmod 4755 /usr/bin/mysecureshell

# Start SSHd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
