FROM  ubuntu:20.04 as builder

USER  root

# ALL tool versions used by opt-build.sh
# need to keep in sync with setup.sh
ARG VER_HTSLIB="1.12"
ARG VER_LIBBW="0.4.6"
ARG VER_LIBDEFLATE="v1.6"

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$PATH
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL C

RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends bzip2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libtasn1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends nettle-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libp11-kit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libncurses5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libgnutls28-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $OPT/bin

WORKDIR /install_tmp

ADD build/opt-build.sh build/
RUN bash build/opt-build.sh $OPT

COPY . .
RUN bash build/opt-build-local.sh $OPT

FROM  ubuntu:20.04

LABEL maintainer="cgphelp@sanger.ac.uk"\
      uk.ac.sanger.cgp="Cancer, Ageing and Somatic Mutation, Wellcome Sanger Institute" \
      description="cgpBigWig"

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$PATH
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL C

RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends \
apt-transport-https \
curl \
ca-certificates \
bzip2 \
zlib1g \
liblzma5 \
libncurses5 \
libcurl3-gnutls \
unattended-upgrades && \
unattended-upgrade -d -v && \
apt-get remove -yq unattended-upgrades && \
apt-get autoremove -yq && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $OPT
COPY --from=builder $OPT $OPT

## USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER    ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]
