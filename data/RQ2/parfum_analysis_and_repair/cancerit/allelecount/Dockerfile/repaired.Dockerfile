FROM  ubuntu:20.04 as builder

USER  root

# ALL tool versions used by opt-build.sh
# need to keep in sync with setup.sh
ENV VER_HTSLIB="1.11"
ENV VER_LIBDEFLATE="v1.6"

RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends
RUN apt-get install -yq --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends bzip2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libtasn1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends nettle-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libp11-kit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -yq --no-install-recommends libncurses5-dev && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$OPT/biobambam2/bin:$PATH
ENV PERL5LIB $OPT/lib/perl5
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# build tools from other repos
ADD build/opt-build.sh build/
RUN bash build/opt-build.sh $OPT

# build the tools in this repo, separate to reduce build time on errors
COPY . .
RUN bash build/opt-build-local.sh $OPT

FROM ubuntu:20.04

LABEL maintainer="cgphelp@sanger.ac.uk" \
      uk.ac.sanger.cgp="Cancer, Ageing and Somatic Mutation, Wellcome Trust Sanger Institute" \
      description="alleleCount docker"

RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends \
apt-transport-https \
locales \
curl \
ca-certificates \
libperlio-gzip-perl \
bzip2 \
psmisc \
time \
zlib1g \
liblzma5 \
libncurses5 \
p11-kit \
unattended-upgrades && \
unattended-upgrade -d -v && \
apt-get remove -yq unattended-upgrades && \
apt-get autoremove -yq && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$OPT/biobambam2/bin:$PATH
ENV PERL5LIB $OPT/lib/perl5
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN mkdir -p $OPT
COPY --from=builder $OPT $OPT

## USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER    ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]
