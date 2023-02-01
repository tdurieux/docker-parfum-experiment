FROM ubuntu
USER root
RUN apt-get update; apt-get install --no-install-recommends -y openjdk-8-jdk-headless wget openssh-server tar vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends apache2 -y && rm -rf /var/lib/apt/lists/*;

#ssh
RUN echo "root:training" | chpasswd
RUN sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chown -R root:root /root/.ssh; chmod -R 700 /root/.ssh
RUN echo "StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
RUN mkdir /var/run/sshd

#Startup
ADD start.sh /

EXPOSE 22 80
CMD bash /start.sh
