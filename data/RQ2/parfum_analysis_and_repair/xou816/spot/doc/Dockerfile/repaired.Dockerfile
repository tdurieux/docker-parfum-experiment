FROM atrendel/doxerlive:15-basic
RUN apk add --no-cache gettext py3-pygments
ADD Makefile /var/doxerlive/
RUN make install