FROM ubuntu:18.04
ENV dir /tmp/dir/
ONBUILD RUN echo "onbuild" > /tmp/onbuild
ONBUILD RUN  mkdir $dir
ONBUILD RUN echo "onbuild 2" > ${dir}/onbuild2
ONBUILD WORKDIR /new/workdir