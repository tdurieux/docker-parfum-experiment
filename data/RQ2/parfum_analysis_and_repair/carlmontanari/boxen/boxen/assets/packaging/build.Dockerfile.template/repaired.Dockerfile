FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && \
    apt-get -yq --no-install-recommends install \
        ca-certificates \
        bridge-utils=1.6* \
        iproute2=5.5.0* \
        socat=1.7.3* \
        cpu-checker=0.7* \
        curl=7.68.0* \
        telnet=0.17-41* \
        linux-image-generic=5.4.* \
        libguestfs-tools=1:1.40* \
        qemu-system-x86=1:4.2* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

ENV BOXEN_TIMEOUT_MULTIPLIER={{ .TimeoutMultiplier }}
ENV BOXEN_LOG_TARGET={{ $.LocalHost }}:6667
ENV BOXEN_LOG_LEVEL=debug
ENV BOXEN_SPARSIFY_DISK={{ $.Sparsify }}

COPY tc-tap-ifup /etc/
RUN chmod 0777 /etc/tc-tap-ifup
COPY boxen.yaml /

{{if not .BinaryOverride }}
RUN bash -c "$( curl -f -sL https://raw.githubusercontent.com/carlmontanari/boxen/main/get.sh)" -f -v {{ .BoxenVersion }} --
{{else}}
RUN curl -f https://{{ $.LocalHost }}:6666/boxen -o boxen
RUN chmod +x boxen && mv boxen /usr/local/bin/boxen
{{end}}

{{range $index, $file := .RequiredFiles -}}
RUN curl -f https://{{ $.LocalHost }}:6666/{{$file}} -o {{$file}}
{{end}}

ENTRYPOINT ["boxen", "package-install"]