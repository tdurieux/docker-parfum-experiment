FROM ubuntu:18.04

###### SERVER SETTING ########
RUN apt-get update
RUN apt-get install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qemu-user-static && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-8-multilib-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y gdb-multiarch

###### USER CREATE ######
RUN useradd -d /home/guest guest

####### note.db user.db ####
RUN touch /note.db
RUN touch /user.db
RUN chmod 766 /note.db
RUN chmod 766 /user.db
# COPY ./SET/flag /flag
# COPY ./PROB/* /home/guest/

#ENTRYPOINT ["runuser", "guest","-c", "/home/guest/run.sh"]
ENTRYPOINT ["/bin/sh"]

