FROM debian:sid
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install shellcheck && rm -rf /var/lib/apt/lists/*;
CMD bash
