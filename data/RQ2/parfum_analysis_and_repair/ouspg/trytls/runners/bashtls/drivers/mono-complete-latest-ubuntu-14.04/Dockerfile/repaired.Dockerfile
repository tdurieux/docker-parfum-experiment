FROM ubuntu:14.04

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  mono-complete && rm -rf /var/lib/apt/lists/*;

COPY scripts /scripts

CMD bash scripts/init; bash '/etc/shared/scripts/drive'
