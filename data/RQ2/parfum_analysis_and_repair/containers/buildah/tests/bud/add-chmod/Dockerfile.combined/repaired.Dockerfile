FROM alpine

ADD --chmod=777 --chown=2367:3267 addchmod.txt /tmp 
RUN stat -c "chmod:%a user:%u group:%g"  /tmp/addchmod.txt 
CMD /bin/sh