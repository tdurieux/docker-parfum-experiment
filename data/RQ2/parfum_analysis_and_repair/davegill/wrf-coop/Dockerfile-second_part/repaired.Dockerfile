#
FROM davegill/wrf-coop:fourteenthtry
MAINTAINER Dave Gill <gill@ucar.edu>

#RUN echo _HERE1_
#RUN git clone https://github.com/davegill/WRF.git davegill/WRF \
#  && cd davegill/WRF \
#  && git fetch origin +refs/pull/4/merge: \
#  && git checkout -qf FETCH_HEAD \
#  && cd .. \
#  && mv WRF /wrf/WRF
#RUN echo _HERE2_