FROM phusion/holy-build-box-64:3.0
ADD . /tr_build
RUN env ARCHITECTURE=x86_64 /tr_build/install.sh