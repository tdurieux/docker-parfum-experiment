FROM ubuntu:16.04

ENV USER noleak
ENV FLAG flag_166903c90eadca6ffac515cd8a6787f2

RUN apt-get update && apt-get install --no-install-recommends -y ed && rm -rf /var/lib/apt/lists/*;

#Adduser
RUN useradd -b /home/noleak noleak

#Copy Binary
ADD $USER /home/$USER/$USER

#Set Flag
ADD flag /home/$USER/$FLAG

#Set Priviledge
RUN chown -R root:$USER /home/$USER
RUN chmod 750 /home/$USER
RUN chmod 750 /home/$USER/$USER
RUN chmod 440 /home/$USER/$FLAG

#COPY start script
ADD ./super.pl /

WORKDIR /home/$USER
CMD ["perl", "/super.pl"]

EXPOSE 7777


