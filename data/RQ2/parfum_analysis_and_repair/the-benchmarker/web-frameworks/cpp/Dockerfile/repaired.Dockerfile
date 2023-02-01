FROM debian:bullseye

WORKDIR /usr/src/app

RUN apt-get -qq update
RUN apt-get -qy --no-install-recommends install build-essential git cmake && rm -rf /var/lib/apt/lists/*;

{{#build_deps}}
  RUN apt-get -qy --no-install-recommends install {{{.}}} && rm -rf /var/lib/apt/lists/*;
{{/build_deps}}

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

{{#environment}}
ENV {{{.}}}
{{/environment}}

WORKDIR /opt/web

RUN apt-get -qq update

{{#bin_deps}}
   RUN apt-get -qy --no-install-recommends install {{{.}}} && rm -rf /var/lib/apt/lists/*;
{{/bin_deps}}

{{#files}}
  COPY {{{.}}} {{{.}}}
{{/files}}

{{#binaries}}
  COPY --from=0 /usr/src/app/{{{.}}} {{{.}}}
{{/binaries}}

CMD {{{command}}}
