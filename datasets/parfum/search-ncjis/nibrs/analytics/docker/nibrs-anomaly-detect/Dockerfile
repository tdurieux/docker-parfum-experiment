FROM rocker/tidyverse

# docker run -it --rm --mount type=bind,source=/opt/data/nibrs/cde,target=/opt/data/nibrs/cde searchncjis/nibrs-anomaly-detect bash
# then look in the /examples directory
# run R, then follow the example

RUN apt-get update && apt-get install -y nano

RUN mkdir -p /nibrs.anomalies
COPY nibrs.anomalies /nibrs.anomalies/

RUN cd /nibrs.anomalies && \
  R -e "devtools::document(roclets = c('rd', 'collate', 'namespace'))" && \
  R -e "devtools::build()" && \
  R -e 'install.packages("/nibrs.anomalies_0.1.0.tar.gz", repos = NULL, type="source")' && \
  cd / && rm -rf nibrs.anomalies && rm nibrs.anomalies_0.1.0.tar.gz

  RUN mkdir -p /examples
  COPY nibrs.anomalies/examples /examples
