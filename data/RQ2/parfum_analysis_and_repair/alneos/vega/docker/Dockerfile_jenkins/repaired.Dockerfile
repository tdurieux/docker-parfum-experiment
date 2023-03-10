FROM ldallolio/vegaci

MAINTAINER Alter Ego Engineering <contact@aego.ai>

USER vega
ENV VEGA_SOURCE=/home/vega/vegapp
ENV VEGA_BUILD=$VEGA_SOURCE/build
COPY --chown=vega:vega . $VEGA_SOURCE
RUN mkdir $VEGA_BUILD
WORKDIR $VEGA_BUILD
RUN . /home/vega/.bashrc && cmake -DRUN_ASTER=OFF -DRUN_SYSTUS=OFF -DCMAKE_BUILD_TYPE=SRelease -DHDF5_LIBRARIES=/opt/aster/public/hdf5-1.10.3/lib/libhdf5.a -DHDF5_INCLUDE_DIRS=/opt/aster/public/hdf5-1.10.3/include -DMEDFILE_C_LIBRARIES=/opt/aster/public/med-4.0.0/lib/libmedC.a -DMEDFILE_INCLUDE_DIRS=/opt/aster/public/med-4.0.0/include .. && make -j && ctest .
FROM scratch
COPY --from=0 /home/vega/vegapp/build/bin/vegapp /
CMD ["/vegapp"]