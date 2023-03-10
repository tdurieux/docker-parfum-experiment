FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y

RUN set -e -x; \
        groupadd -g 1337 user; \
        useradd -g 1337 -u 1337 -m user

COPY attachments/chal /home/user/
COPY flag /home/user/

RUN set -e -x; \
    chown -R root:root /home/user; \
    chmod 555 /home/user; \
    chmod 555 /home/user/chal; \
    chmod 444 /home/user/flag

USER user
CMD cd /home/user && ./chal