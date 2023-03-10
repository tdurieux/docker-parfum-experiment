FROM ubuntu:18.04@sha256:139b3846cee2e63de9ced83cee7023a2d95763ee2573e5b0ab6dea9dfbd4db8f
COPY ubuntu_18.04_deps.sh /deps.sh
COPY requirements.txt /requirements.txt
RUN /deps.sh && rm /deps.sh
CMD cd /sdk && ./tools/build.sh --clang