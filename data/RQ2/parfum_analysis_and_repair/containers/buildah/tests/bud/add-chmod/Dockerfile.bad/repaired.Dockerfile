FROM alpine

ADD --chmod 777 addchmod.txt /tmp 
RUN ls -l /tmp/addchmod.txt 
CMD /bin/sh