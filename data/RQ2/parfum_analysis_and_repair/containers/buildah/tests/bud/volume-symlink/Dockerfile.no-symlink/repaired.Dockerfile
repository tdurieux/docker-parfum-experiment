FROM alpine
RUN mkdir -p /home/app/myvolume \
&& touch /home/app/myvolume/foo.txt
VOLUME ["/home/app/myvolume"]