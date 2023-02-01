FROM darpaalign/klayout:latest as layout_convert

RUN apt-get update && apt-get install --no-install-recommends -yq xvfb && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY . /build/ThirdParty/Klayout/
