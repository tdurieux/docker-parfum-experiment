FROM magicpak/debian:buster-magicpak1.3.1

RUN apt-get -y update && apt-get -y --no-install-recommends install clang-format && rm -rf /var/lib/apt/lists/*;

RUN magicpak $(which clang-format) /bundle -v  \
      --compress                               \
      --upx-arg --best                         \
      --test                                   \
      --test-stdin "int main(  ){ }"           \
      --test-stdout "int main() {}"            \
      --install-to /bin/

FROM scratch
COPY --from=0 /bundle /.

WORKDIR /workdir

CMD ["/bin/clang-format"]
