FROM debian:bullseye

WORKDIR /usr/src/app

RUN apt-get -qq update
RUN apt-get -qy --no-install-recommends install build-essential wget && rm -rf /var/lib/apt/lists/*;

{{#build_deps}}
  RUN apt-get -qy --no-install-recommends install {{{.}}} && rm -rf /var/lib/apt/lists/*;
{{/build_deps}}

WORKDIR /usr/src/app

{{#sources}}
   COPY {{{.}}} {{{.}}}
{{/sources}}

{{#download}}
  RUN {{{.}}}
{{/download}}

{{#build}}
   RUN {{{.}}}
{{/build}}

FROM debian:bullseye

WORKDIR /opt/web

RUN apt-get -qq update

{{#bin_deps}}
   RUN apt-get -qy --no-install-recommends install {{{.}}} && rm -rf /var/lib/apt/lists/*;
{{/bin_deps}}

{{#files}}
   COPY {{{.}}} {{{.}}}
{{/files}}

{{#binaries}}
   COPY --from=0 /usr/src/app/{{.}} {{{.}}}
{{/binaries}}

CMD {{{command}}}
