## Emacs, make this -*- mode: sh; -*-

FROM r-base:3.4.4

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/RcppCore/Rcpp" \
      maintainer="Dirk Eddelbuettel <edd@debian.org>"

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                git \
        && install.r inline pkgKitten rbenchmark tinytest && rm -rf /var/lib/apt/lists/*;

ENV _R_CHECK_FORCE_SUGGESTS_ FALSE
ENV _R_CHECK_TESTS_NLINES_ 0
ENV RunAllRcppTests yes

CMD ["bash"]
