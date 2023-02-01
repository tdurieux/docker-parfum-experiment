FROM mkaczanowski/archlinuxarm:armv8 as builder

RUN pacman -Sy --noconfirm rustup gcc llvm clang glibc
RUN rustup default nightly

WORKDIR /usr/src/pastebin
COPY . .

RUN cargo install --path . --root /tmp/pastebin

FROM mkaczanowski/archlinuxarm:armv8
RUN pacman -Sy --noconfirm glibc
COPY --from=builder /tmp/pastebin/bin/pastebin /usr/local/bin/pastebin

ENTRYPOINT ["pastebin"]
CMD ["--help"]