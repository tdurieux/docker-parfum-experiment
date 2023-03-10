FROM alpine:3.16

RUN apk add --no-cache \
		ca-certificates \
# Workaround for golang not producing a static ctr binary on Go 1.15 and up https://github.com/containerd/containerd/issues/5824
		libc6-compat \
# DOCKER_HOST=ssh://... -- https://github.com/docker/cli/pull/1014
		openssh-client

# set up nsswitch.conf for Go's "netgo" implementation (which Docker explicitly uses)
# - https://github.com/docker/docker-ce/blob/v17.09.0-ce/components/engine/hack/make.sh#L149
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
# - docker run --rm debian:stretch grep '^hosts:' /etc/nsswitch.conf
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV DOCKER_VERSION {{ .version }}
# TODO ENV DOCKER_SHA256
# https://github.com/docker/docker-ce/blob/5b073ee2cf564edee5adca05eee574142f7627bb/components/packaging/static/hash_files !!
# (no SHA file artifacts on download.docker.com yet as of 2017-06-07 though)

{{
	def apkArch:
		{
			# https://dl-cdn.alpinelinux.org/alpine/edge/main/
			# https://wiki.alpinelinux.org/wiki/Architecture#Alpine_Hardware_Architecture_.28.22arch.22.29_Support
			# https://pkgs.alpinelinux.org/packages ("Arch" dropdown)
			amd64: "x86_64",
			arm32v6: "armhf",
			arm32v7: "armv7",
			arm64v8: "aarch64",
			i386: "x86",
			ppc64le: "ppc64le",
			riscv64: "riscv64",
			s390x: "s390x",
		}[.]
-}}
RUN set -eux; \
	\
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
{{
	[
		.arches | to_entries[]
		| .key as $bashbrewArch
		| ($bashbrewArch | apkArch) as $apkArch
		| .value
		| select($apkArch and .dockerUrl)
		| (
-}}
		{{ $apkArch | @sh }}) \
			url={{ .dockerUrl | @sh }}; \
			;; \
{{
		)
	] | add
-}}
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;; \
	esac; \
	\
	wget -O docker.tgz "$url"; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version
{{
	{
		buildx: .buildx,
		compose: .compose,
	}
	| to_entries | map(
		.key as $key | .value | (
-}}

ENV DOCKER_{{ $key | ascii_upcase }}_VERSION {{ .version }}
RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
{{
			.arches | to_entries | map(
				.key as $bashbrewArch
				| ($bashbrewArch | apkArch) as $apkArch
				| .value
				| select($apkArch and .url and .sha256)
				| (
-}}
		{{ $apkArch | @sh }}) \
			url={{ .url | @sh }}; \
			sha256={{ .sha256 | @sh }}; \
			;; \
{{
				)
			) | add
-}}
		*) echo >&2 "warning: unsupported {{ $key }} architecture ($apkArch); skipping"; exit 0 ;; \
	esac; \
	plugin='/usr/libexec/docker/cli-plugins/docker-{{ $key }}'; \
	mkdir -p "$(dirname "$plugin")"; \
	wget -O "$plugin" "$url"; \
	echo "$sha256 *$plugin" | sha256sum -c -; \
	chmod +x "$plugin"; \
{{ if $key == "compose" then ( -}}
	ln -sv "$plugin" /usr/local/bin/; \
	docker-{{ $key }} --version; \
{{ ) else "" end -}}
	docker {{ $key }} version
{{
		)
	)
	| add
-}}

COPY modprobe.sh /usr/local/bin/modprobe
COPY docker-entrypoint.sh /usr/local/bin/

# https://github.com/docker-library/docker/pull/166
#   dockerd-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-generating TLS certificates
#   docker-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-setting DOCKER_TLS_VERIFY and DOCKER_CERT_PATH
# (For this to work, at least the "client" subdirectory of this path needs to be shared between the client and server containers via a volume, "docker cp", or other means of data sharing.)
ENV DOCKER_TLS_CERTDIR=/certs
# also, ensure the directory pre-exists and has wide enough permissions for "dockerd-entrypoint.sh" to create subdirectories, even when run in "rootless" mode
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client
# (doing both /certs and /certs/client so that if Docker does a "copy-up" into a volume defined on /certs/client, it will "do the right thing" by default in a way that still works for rootless users)

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]