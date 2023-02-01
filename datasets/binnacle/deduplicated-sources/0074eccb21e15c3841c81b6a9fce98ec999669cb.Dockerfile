FROM byuoitav/arm32v6-alpine
MAINTAINER Daniel Randall <danny_randall@byu.edu>

ARG NAME
ENV name=${NAME}

COPY ${name}-arm ${name}-arm
COPY version.txt version.txt

# add any required files/folders here

ENTRYPOINT ./${name}-arm
