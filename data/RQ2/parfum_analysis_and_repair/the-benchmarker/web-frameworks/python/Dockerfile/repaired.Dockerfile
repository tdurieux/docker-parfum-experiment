FROM python:3.10-slim

WORKDIR /usr/src/app

RUN apt-get -qq update
RUN apt-get -qy --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

{{#build_deps}}
  RUN apt-get -qy --no-install-recommends install {{{.}}} && rm -rf /var/lib/apt/lists/*;
{{/build_deps}}

COPY . ./

{{#fixes}}
  RUN {{{.}}}
{{/fixes}}

{{#environment}}
  ENV {{{.}}}
{{/environment}}

RUN pip install --no-cache-dir -r requirements.txt

CMD {{command}}
