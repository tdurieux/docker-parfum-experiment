FROM slamantic/base

ADD . /app
RUN cd /app && ./build_orb.sh
WORKDIR /app