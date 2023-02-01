FROM ubuntu:18.04
LABEL maintainer="stothard@ualberta.ca"
LABEL description="CGView is a Java package for generating high-quality, zoomable maps of circular genomes."

RUN apt-get update && apt-get install --no-install-recommends -y \
  apt-utils \
  build-essential \
  cpanminus \
  default-jre \
  expat \
  libexpat-dev \
  perl && rm -rf /var/lib/apt/lists/*;

RUN cpanm --force XML::DOM::XPath

RUN cpanm CPAN::Meta \
 Bio::SeqIO \
 Bio::SeqUtils \ 
 Tie::IxHash

WORKDIR /usr/bin

COPY bin/cgview.jar .

COPY scripts/cgview_xml_builder/cgview_xml_builder.pl .
