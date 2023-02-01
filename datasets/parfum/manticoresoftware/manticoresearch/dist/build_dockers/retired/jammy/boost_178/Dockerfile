FROM registry.gitlab.com/manticoresearch/dev/jammy_clang:13

ARG boostminorver=78
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.${boostminorver}.0/source/boost_1_${boostminorver}_0.tar.gz \
    && tar -zxf boost_1_${boostminorver}_0.tar.gz && rm boost_1_${boostminorver}_0.tar.gz \
    && cd boost_1_${boostminorver}_0 \
    && ./bootstrap.sh \
    && ./b2 install toolset=clang-13 --with-context --with-system --with-fiber --with-program_options --with-stacktrace \
    && cd .. && rm -rf boost_1_${boostminorver}_0

CMD []

# docker build -t jammy_boost:178 -t registry.gitlab.com/manticoresearch/dev/jammy_boost:178 .
