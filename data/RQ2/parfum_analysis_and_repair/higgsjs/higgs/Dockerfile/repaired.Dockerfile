FROM dlanguage/dmd:2.073.2

COPY . /src/

WORKDIR /src/source

RUN apt-get update \
 && apt-get install --no-install-recommends -y build-essential python \
 && make all \
 && apt-get auto-remove && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/src/source/higgs"]
