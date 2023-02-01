#
# Stage 'build-ephyr' builds Ephyr for the final stage.
#

# https://hub.docker.com/_/rust
FROM instrumentisto/rust AS build-ephyr


# Create user and group files, which will be used in a running container to
# run the process as an unprivileged user.
RUN mkdir -p /out/etc/ \
 && echo 'nobody:x:65534:65534:nobody:/:' > /out/etc/passwd \
 && echo 'nobody:x:65534:' > /out/etc/group


# First, build all the dependencies to cache them in a separate Docker layer and
# avoid recompilation each time project sources are changed.
WORKDIR /tmp/ephyr/

COPY common/api/allatra-video/Cargo.toml ./common/api/allatra-video/
COPY common/log/Cargo.toml ./common/log/
COPY common/serde/Cargo.toml ./common/serde/
COPY components/restreamer/Cargo.toml ./components/restreamer/
COPY components/vod-meta-server/Cargo.toml ./components/vod-meta-server/
COPY Cargo.toml Cargo.lock ./

RUN mkdir -p common/api/allatra-video/src/ \
 && touch common/api/allatra-video/src/lib.rs \
 && mkdir -p common/log/src/ \
 && touch common/log/src/lib.rs \
 && mkdir -p common/serde/src/ \
 && touch common/serde/src/lib.rs \
 && mkdir -p components/restreamer/src/ \
 && touch components/restreamer/src/lib.rs components/restreamer/src/main.rs \
 && mkdir -p components/vod-meta-server/src/ \
 && touch components/vod-meta-server/src/lib.rs

RUN cargo build -p ephyr-vod-meta-server --lib --release

# Finally, build the whole project.
RUN rm -rf ./target/release/.fingerprint/ephyr-*

COPY common/api/allatra-video/ ./common/api/allatra-video/
COPY common/log/ ./common/log/
COPY common/serde/ ./common/serde/
COPY components/vod-meta-server/src/ ./components/vod-meta-server/src/

RUN cargo build -p ephyr-vod-meta-server --bin ephyr-vod-meta-server --release


# Prepare project distribution binary and all dependent dynamic libraries.
RUN cp /tmp/ephyr/target/release/ephyr-vod-meta-server \
       /out/ephyr-vod-meta-server \
 && ldd /out/ephyr-vod-meta-server \
        # These libs are not reported by ldd(1) on binary,
        # but are vital for DNS resolution.
        # See: https://forums.aws.amazon.com/thread.jspa?threadID=291609
        /lib/x86_64-linux-gnu/libnss_dns.so.2 \
        /lib/x86_64-linux-gnu/libnss_files.so.2 \
    | awk 'BEGIN{ORS=" "}$1~/^\//{print $1}$3~/^\//{print $3}' \
    | sed 's/,$/\n/' \
    | tr -d ':' \
    | tr ' ' "\n" \
    | xargs -I '{}' cp -fL --parents '{}' /out/ \
 && rm -rf /out/out




#
# Stage 'runtime' creates final Docker image to use in runtime.
#

# https://hub.docker.com/_/scratch