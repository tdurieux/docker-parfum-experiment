FROM trikset/checker-runtime
MAINTAINER Iakov Kirilenko <Iakov.Kirilenko@trikset.com>
ENV DEBIAN_FRONTEND noninteractive
ARG CHECKER_TAG=master

# Add binaries before ldconfig & prelink.
RUN curl -f -v -- https://dl.trikset.com/ts/fresh/checker/checker-linux-release-${CHECKER_TAG}.tar.xz \
      | tar xvJ
#HOTFIX: must be removed after corresponding fix in trikRuntime
RUN ln -s /trikStudio-checker/bin/libpython3.${TRIK_PYTHON3_VERSION_MINOR}.so.1.0 /trikStudio-checker/bin/libpython3.${TRIK_PYTHON3_VERSION_MINOR}.so


#Run everything at once to create a single layer
RUN useradd -M -d /sandbox sandbox \
    && /bin/echo -e "/trikStudio-checker/bin\n" > /etc/ld.so.conf.d/zz_trik_libs.conf \
    && echo '-l /trikStudio-checker' >> /etc/prelink.conf \
    && ldconfig -v

ENV LANG ru_RU.UTF-8
RUN du -csh /* 2>/dev/null | sort -h || :
