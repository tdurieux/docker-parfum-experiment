# update the version here as needed
# may bring updates to things like musl so proceed carefully.
# via https://hub.docker.com/_/alpine
FROM alpine:3.13.0

RUN apk add --no-cache --update-cache \

    cmake make g++ \

    linux-headers \

    clang \

    openssl-dev openssl-libs-static

# install patched rust from edge, for the specified version
ARG RUST_VERSION
RUN apk add --no-cache --update-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    # using apk's fuzzy version matching
    # https://git.alpinelinux.org/apk-tools/commit/?id=693b4bcdb0f22904a521a7c8ac4f13e697dc4d71
    "cargo" --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    # using apk's fuzzy version matching
    # https://git.alpinelinux.org/apk-tools/commit/?id=693b4bcdb0f22904a521a7c8ac4f13e697dc4d71
    "cargo"

# This doesn't work since we don't controle what version alpine offers, so we just grab the latest instead
# "cargo=~${RUST_VERSION}"
# alpine doesn't keep old package versions around (https://gitlab.alpinelinux.org/alpine/abuild/-/issues/9996)
# so if the above strategy causes issues, we can opt for the below strategy.
# Better to bump our project's rust version at that point though (unless
# there's a strong reason not to).
#"cargo>=${RUST_VERSION}"

# only alpine's patched rustc has worked for succesful snmalloc musl builds
# so installing rust this way does not quite work
#
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh \
#    && sh rustup-init.sh -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION
#    && rm rustup-init.sh
#
#ENV PATH="/root/.cargo/bin:${PATH}"
#
#RUN rustup target add x86_64-unknown-linux-musl

COPY shared/entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
