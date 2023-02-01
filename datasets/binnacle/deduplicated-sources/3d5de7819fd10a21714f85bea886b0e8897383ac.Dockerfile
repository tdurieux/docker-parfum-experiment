FROM cloudsuite/spark

# Benchmark files
COPY movielens-als /root/movielens-als

WORKDIR /root

# Build the benchmark using sbt
RUN set -x \
    && echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 \
    && apt-get update -y && apt-get install -y --no-install-recommends sbt \
    && rm -rf /var/lib/apt/lists/* \
    && (cd movielens-als && sbt package) \
    && mkdir -p /benchmarks/movielens-als \
    && mv movielens-als/target/scala-2.10/*.jar movielens-als/run_benchmark.sh /benchmarks/movielens-als \
    && rm -r movielens-als \
    && apt-get purge -y --auto-remove sbt \
    && rm -r .sbt .ivy2

COPY files /root/

ENTRYPOINT ["/root/entrypoint.sh"]

