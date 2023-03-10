FROM alpine

COPY --chmod=777 --chown=2367:3267 copychmod.txt /tmp 
RUN stat -c "chmod:%a user:%u group:%g"  /tmp/copychmod.txt 
CMD /bin/sh