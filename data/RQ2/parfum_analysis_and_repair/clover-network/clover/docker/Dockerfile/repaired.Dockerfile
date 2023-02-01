FROM cloverio/runtime-linux-production:bullseye

# Install required dependencies
RUN apt-get update && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

COPY clover /opt/clover/bin/clover
COPY specs /opt/specs

WORKDIR /opt/clover
CMD /opt/clover/bin/clover $ARGS
