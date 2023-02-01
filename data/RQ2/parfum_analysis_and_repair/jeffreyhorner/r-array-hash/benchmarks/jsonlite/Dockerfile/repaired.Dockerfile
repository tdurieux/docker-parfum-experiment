## Get Jeffreys Image
FROM jeffreyhorner/r-array-hash

## Install requirements
RUN mkdir -p ~/R312 && \
    mkdir -p ~/R320 && \
    R --quiet -e '.libPaths("~/R312"); install.packages(c("devtools", "microbenchmark"));devtools::install_github("jeroenooms/jsonlite");' > /dev/null 2>&1 && \
    RD --quiet -e '.libPaths("~/R320"); install.packages(c("devtools", "microbenchmark"));devtools::install_github("jeroenooms/jsonlite");' > /dev/null 2>&1

## The actual benchmarks