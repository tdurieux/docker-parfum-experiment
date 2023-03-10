FROM stretch_erlang22

#
# Built with:
# docker build --tag=stretch_elixir110 -f docker/Dockerfile.Stretch.Elixir110 .
#

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.10.0" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA256="6f0d35acfcbede5ef7dced3e37f016fd122c2779000ca9dcaf92975b220737b7" \
	&& curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256 elixir-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/local/src/elixir \
	&& tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
	&& rm elixir-src.tar.gz \
	&& cd /usr/local/src/elixir \
	&& make install clean

CMD ["iex"]