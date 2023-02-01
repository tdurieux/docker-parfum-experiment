FROM rocker/tidyverse

RUN R -e 'devtools::install_github("hrbrmstr/sergeant")'
RUN R -e 'install.packages("arrow")'
RUN R -e 'arrow::install_arrow()'

RUN mkdir -p /cde.extract
COPY cde.extract /cde.extract/

RUN cd /cde.extract && \
  R -e "devtools::document(roclets = c('rd', 'collate', 'namespace'))" && \
  R -e "devtools::build()" && \
  R -e 'install.packages("/cde.extract_0.1.0.tar.gz", repos = NULL, type="source")' && \
  cd / && rm -rf cde.extract && rm cde.extract_0.1.0.tar.gz

RUN mkdir -p /output
COPY cde.extract.sh /tmp/
RUN chmod ugo+x /tmp/cde.extract.sh

WORKDIR /

ENV year_regex .+
ENV state_regex .+
ENV drill_host nibrs-analytics-drill

RUN mkdir -p /output

CMD "/tmp/cde.extract.sh"
