# Development only docker, run with `docker run -it -v $(pwd):/balde balde make check`
# in example.
FROM balde/balde
RUN apt-get update && apt-get install --no-install-recommends valgrind libglib2.0-0-dbg -y && apt-get clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /balde
