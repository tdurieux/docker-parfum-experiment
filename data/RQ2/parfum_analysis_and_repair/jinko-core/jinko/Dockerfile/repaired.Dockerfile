#        ██╗██╗███╗   ██╗██╗  ██╗ ██████╗     ██╗  ██╗    ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗
#        ██║██║████╗  ██║██║ ██╔╝██╔═══██╗    ╚██╗██╔╝    ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
#        ██║██║██╔██╗ ██║█████╔╝ ██║   ██║     ╚███╔╝     ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝
#   ██   ██║██║██║╚██╗██║██╔═██╗ ██║   ██║     ██╔██╗     ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
#   ╚█████╔╝██║██║ ╚████║██║  ██╗╚██████╔╝    ██╔╝ ██╗    ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║
#    ╚════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝     ╚═╝  ╚═╝    ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝


# Build the jinko interpreter
# ---------------------------

FROM rust:slim-bullseye as build

COPY . /jinko
WORKDIR /jinko
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --target=x86_64-unknown-linux-musl --no-default-features --features repl --release
RUN strip /jinko/target/x86_64-unknown-linux-musl/release/jinko


# Get the needed libs (not statically linked)
# -------------------------------------------

FROM alpine:3.15.0 as libs
RUN apk add --no-cache ncurses-libs


# Run the jinko interpreter in a fresh container
# ----------------------------------------------