############
# BASICS
#
# Implements a VolCon mirror that can temporarily store job files for a particular job
#
############


FROM python:3.6-alpine


COPY mirror.sh /mirror/mirror
COPY mirror.py /mirror/mirror.py


# Installs the necessary packages
# Bash, curl for convenience
RUN apk update && apk add --no-cache bash curl && \
    pip3 install --no-cache-dir gunicorn Flask requests && \
    chmod +x /mirror/mirror


WORKDIR /mirror


CMD ["/mirror/mirror"]

