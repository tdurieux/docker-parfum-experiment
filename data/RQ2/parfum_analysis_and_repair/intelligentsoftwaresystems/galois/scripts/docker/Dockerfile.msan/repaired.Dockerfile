FROM quick-dev
COPY msan /tmp/msan
RUN bash -x /tmp/msan/build-llvm.sh \
      && bash -x /tmp/msan/build-boost.sh \
      && rm -r /tmp/msan