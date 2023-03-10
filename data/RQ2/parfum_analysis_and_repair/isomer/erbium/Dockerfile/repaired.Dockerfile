# Really basic docker file for erbium.
# To use, run something like:
#
# docker run --network host -v /path/to/dir/with/conf:/config -v /path/to/data/dir:/var/lib/erbium \
#   ghcr.io/jelmer/erbium


FROM debian:sid
ADD . /code
RUN apt -y update && apt -y --no-install-recommends install cargo libsqlite3-dev && cd /code && cargo build --release && rm -rf /var/lib/apt/lists/*;
CMD /code/target/release/erbium /config/erbium.conf
