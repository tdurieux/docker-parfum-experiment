FROM fedora:24
MAINTAINER \
[Adam Miller <maxamillion@fedoraproject.org>] \
[Patrick Uiterwijk <patrick@puiterwijk.org>]
ENV DISTTAG=f24docker FGC=f24
LABEL description="This is base Docker image for forensics analysis machines"
ARG lab
ARG labdir

RUN dnf update -y 
RUN dnf install -y vim sudo net-tools less man python procps-ng tcl expect wget openssh-server
RUN dnf install -y findutils
RUN wget https://forensics.cert.org/cert-forensics-tools-release-24.rpm && rpm -ivh cert-forensics-tools-release-24.rpm
#RUN dnf install -y CERT-Forensics-Tools # adding this line installs all the tools but you end up with a 4.59 Gig container instead of a 946MB container.

EXPOSE 22

ADD $labdir/fed_sudoers /etc/sudoers
RUN useradd -ms /bin/bash abby
RUN echo "abby:abby" | chpasswd
RUN chown -R abby:abby /home/abby
RUN usermod abby -a -G wheel 
ADD $lab.student.tar.gz /home/abby
 
USER abby
ENV HOME /home/abby
RUN echo "source $HOME/.local/bin/bash-preexec.sh" >> /home/abby/.bash_profile
RUN echo "source $HOME/.local/bin/bash-pre-capinout.sh" >> /home/abby/.bash_profile
RUN echo "cd" >> $HOME/.bash_profile
RUN echo "source $HOME/.local/bin/startup.sh" >> /home/abby/.bash_profile
RUN echo "" > $HOME/.bash_logout

RUN mkdir $HOME/volatile
RUN mkdir $HOME/nonvolatile
RUN mkdir $HOME/interesting

#ENTRYPOINT sudo systemctl start sshd.service && bash

