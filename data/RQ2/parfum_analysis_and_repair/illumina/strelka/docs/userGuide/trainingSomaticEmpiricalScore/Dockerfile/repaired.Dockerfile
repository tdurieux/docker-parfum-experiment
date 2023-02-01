#
# minimum environment required to run Strelka somatic EVS training procedures
#

FROM ubuntu:14.04

#
# major required packages:
#
# - python
# - numpy
# - pandas
# - pip
# - scikit-learn
# - bx-python
#
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq python python-numpy python-pandas && \
    apt-get install -y --no-install-recommends -qq python-pip python-dev build-essential && \
    pip install --no-cache-dir -U scikit-learn && \
    apt-get install -y --no-install-recommends -qq zlib1g-dev && \
    pip install --no-cache-dir bx-python && rm -rf /var/lib/apt/lists/*;

#
# Optional packages for visualization discussed
# in user guide but not required for training:
#
# - R
# - R-ggplot2
#
RUN apt-get install -y --no-install-recommends -qq r-base r-cran-ggplot2 && rm -rf /var/lib/apt/lists/*;

