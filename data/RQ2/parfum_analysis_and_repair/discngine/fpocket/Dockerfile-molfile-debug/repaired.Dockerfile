FROM ubuntu:latest
RUN groupadd -r fpocket && useradd --no-log-init -r -g fpocket fpocket
ENV DEBIAN_FRONTEND=noninteractive
ENV PLUGINDIR=compiled
RUN apt update -y && apt install --no-install-recommends -y vim gdb gcc g++ make libnetcdf-dev && rm -rf /var/lib/apt/lists/*

# all of this mess is essentially to have a minimalistic build at the end
COPY vmd /vmd
WORKDIR /vmd/plugins
RUN make LINUXAMD64 && make distrib

COPY makefile /opt/fpocket/
COPY src /opt/fpocket/src
COPY data/sample /opt/fpocket/sample
COPY man /opt/fpocket/man
COPY headers /opt/fpocket/headers
COPY obj /opt/fpocket/obj
COPY scripts /opt/fpocket/scripts
COPY bin /opt/fpocket/bin
COPY plugins/LINUXAMD64 /opt/fpocket/plugins/LINUXAMD64
COPY plugins/include /opt/fpocket/plugins/include
COPY plugins/noarch /opt/fpocket/plugins/noarch

WORKDIR /opt/fpocket
RUN cp -r /vmd/plugins/molfile_plugin/compiled/LINUXAMD64/molfile/* plugins/LINUXAMD64/molfile/
#RUN make && make install && make clean
USER fpocket
WORKDIR /tmp
CMD ["fpocket"]