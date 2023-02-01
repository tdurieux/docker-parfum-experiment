#-----------------------------------------------------------------------------#
#    Dockerfile to build an image to run MMITSS applications natively         #
#    The image can be used to spawn containers that can simulate each         #
#    MRP/VSP that needs to be present in the simulated network                #
#                                                                             #
#    Image name: mmitssuarizona/mmitss-x86-base                               #
#-----------------------------------------------------------------------------#
FROM ubuntu:20.04

MAINTAINER D Cunningham (donaldcunningham@email.arizona.edu)

# perform a sysupgrade and install some necessary packages -

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils supervisor iputils-ping net-tools tzdata && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/supervisor

COPY lib/x86/system/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/
COPY lib/x86/system/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/


# Add the shared libraries mmitss needs in order to run
COPY 3rdparty/net-snmp/lib/x86/libnetsnmp.so.35.0.0 /usr/local/lib/mmitss/
COPY 3rdparty/glpk/lib/x86/libglpk.so.35.1.0 /usr/local/lib/mmitss/
COPY lib/x86/libmmitss-common.so /usr/local/lib/mmitss/
COPY 3rdparty/mapengine/lib/x86/liblocAware.so.1.0 /usr/local/lib/mmitss/
COPY 3rdparty/asn1j2735/lib/x86/libasn.so.1.0 /usr/local/lib/mmitss/
COPY 3rdparty/asn1j2735/lib/x86/libdsrc.so.1.0 /usr/local/lib/mmitss/
COPY lib/mmitss.conf /etc/ld.so.conf.d/

# Create the symbolic links for the copied libraries."
RUN ln -s /usr/local/lib/mmitss/libnetsnmp.so.35.0.0 /usr/local/lib/mmitss/libnetsnmp.so.35 && ln -s /usr/local/lib/mmitss/libglpk.so.35.1.0 /usr/local/lib/mmitss/libglpk.so.35
RUN ln -s /usr/local/lib/mmitss/liblocAware.so.1.0 /usr/local/lib/mmitss/liblocAware.so && ln -s /usr/local/lib/mmitss/libasn.so.1.0 /usr/local/lib/mmitss/libasn.so
RUN ln -s /usr/local/lib/mmitss/libdsrc.so.1.0 /usr/local/lib/mmitss/libdsrc.so
# Alpine - RUN ldconfig /etc/ld.so.conf.d/
RUN ldconfig

RUN mkdir /mmitss
RUN mkdir /var/net-snmp
RUN mkdir /var/net-snmp/mib_indexes

WORKDIR /mmitss

# Environment variables
ENV PATH $PATH:/mmitss
ENV MIBS=ALL
