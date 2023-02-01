FROM gridss/gridss:2.9.4
LABEL base.image="gridss/gridss:2.9.4"

RUN apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y wget pkg-config libgd-dev libmagick++-dev ; apt-get clean ; rm -rf /var/lib/apt/lists/*

# circos installation
# not using the ubuntu circos package as it places the conf files in /etc/circos which breaks << include etc/*.conf >> as CIRCOS_PATH/etc/circos is not on the circos search path
ENV CIRCOS_VERSION=0.69-9
RUN mkdir /opt/circos && \
	cd /opt/circos && \
	wget http://circos.ca/distribution/circos-${CIRCOS_VERSION}.tgz && \
	tar zxvf circos-${CIRCOS_VERSION}.tgz && \
	rm circos-${CIRCOS_VERSION}.tgz
ENV CIRCOS_HOME=/opt/circos/circos-${CIRCOS_VERSION}
ENV PATH=${CIRCOS_HOME}/bin:${PATH}
RUN cpan App::cpanminus
RUN cpanm List::MoreUtils Math::Bezier Math::Round Math::VecStat Params::Validate Readonly Regexp::Common SVG Set::IntSpan Statistics::Basic Text::Format Clone Config::General Font::TTF::Font GD

# LINX visualisation libraries
RUN Rscript -e 'options(Ncpus=16L, repos="https://cloud.r-project.org/");install.packages(c("tidyverse", "cowplot", "magick", "NMF"))'
RUN Rscript -e 'options(Ncpus=16L, repos="https://cloud.r-project.org/");BiocManager::install(ask=FALSE, pkgs=c("Gviz"))'

################## METADATA ######################

LABEL version="1"
LABEL software="GRIDSS PURPLE LINX"
LABEL software.version="1.3.2"
LABEL about.summary="Somatic GRIDSS/PURPLE/LINX SV/CNV detection and interpretation pipeline"
LABEL about.home="https://github.com/hartwigmedical/gridss-purple-linx"
LABEL about.tags="Genomics"

ENV GRIDSS_VERSION=2.9.4
ENV GRIPSS_VERSION=1.9
ENV AMBER_VERSION=3.5
ENV COBALT_VERSION=1.11
ENV PURPLE_VERSION=2.51
ENV LINX_VERSION=1.12
ENV SAGE_VERSION=2.4

ENV GRIPSS_JAR=/opt/hmftools/gripss-${GRIPSS_VERSION}.jar
ENV AMBER_JAR=/opt/hmftools/amber-${AMBER_VERSION}.jar
ENV COBALT_JAR=/opt/hmftools/cobalt-${COBALT_VERSION}.jar 
ENV PURPLE_JAR=/opt/hmftools/purple-${PURPLE_VERSION}.jar
ENV LINX_JAR=/opt/hmftools/sv-linx_v${LINX_VERSION}.jar
ENV SAGE_JAR=/opt/hmftools/sage-${SAGE_VERSION}.jar

COPY package/ /opt/

ENTRYPOINT ["/opt/gridss-purple-linx/gridss-purple-linx.sh"]

