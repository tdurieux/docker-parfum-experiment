FROM alpine

COPY --chmod=777 copychmod.txt /tmp 
RUN ls -l /tmp/copychmod.txt 
CMD /bin/sh