## Emacs, make this -*- mode: sh; -*-

FROM r-base:latest

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/RcppCore/Rcpp" \
      maintainer="Dirk Eddelbuettel <edd@debian.org>"

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                libcurl4-openssl-dev \
                libssl-dev \
                r-cran-covr \
                r-cran-inline \
                r-cran-pkgkitten \
                r-cran-tinytest \
                r-cran-xml2 \
                git \
        && install.r rbenchmark

ENV _R_CHECK_FORCE_SUGGESTS_ FALSE
ENV _R_CHECK_TESTS_NLINES_ 0
ENV RunAllRcppTests yes

CMD ["bash"]
