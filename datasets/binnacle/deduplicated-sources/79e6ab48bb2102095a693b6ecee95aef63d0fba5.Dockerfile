# sshd
#
# VERSION               0.0.3

FROM ubuntu:18.04
MAINTAINER InteractiveShell Team <trym2@googlegroups.com>

# For ssh server and up-to-date ubuntu.
RUN apt-get update && apt-get install -yq openssh-server wget gnupg

# gfan
RUN apt-get install -yq gfan libglpk40

# Installing M2
RUN echo "deb http://www.math.uiuc.edu/Macaulay2/Repositories/Ubuntu bionic main" >> /etc/apt/sources.list
RUN wget http://www.math.uiuc.edu/Macaulay2/PublicKeys/Macaulay2-key
RUN apt-key add Macaulay2-key
RUN apt-get update && apt-get install -y macaulay2

# RUN apt-get install -y polymake    ## too long and big
RUN apt-get install -yq graphviz

# M2 userland, part 1.    
RUN useradd -m -d /home/m2user m2user
RUN mkdir /custom
#RUN chown -R m2user:m2user /usr/share/Macaulay2
RUN chown -R m2user:m2user /custom
RUN chmod -R 775 /custom

# Bertini and PHCpack
ENV PHC_VERSION 24
RUN (cd /custom; wget http://www.math.uic.edu/~jan/x86_64phcv${PHC_VERSION}p.tar.gz)
RUN (cd /custom; tar zxf x86_64phcv${PHC_VERSION}p.tar.gz; mv phc /usr/bin; rm x86_64phcv${PHC_VERSION}p.tar.gz)
# This is the only way extracting Bertini gives the right permissions.
ENV BERTINI_VERSION 1.5.1
RUN apt-get install -yq libmpfr6
RUN su m2user -c "/bin/bash;\
   cd /custom;\
   wget https://bertini.nd.edu/BertiniLinux64_v${BERTINI_VERSION}.tar.gz;\ 
   tar xzf BertiniLinux64_v${BERTINI_VERSION}.tar.gz;"
RUN ln -s /custom/BertiniLinux64_v${BERTINI_VERSION}/bin/bertini /usr/bin/
RUN cp -a /custom/BertiniLinux64_v${BERTINI_VERSION}/lib/* /usr/lib/
