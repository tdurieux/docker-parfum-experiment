{{
	def is_alpine:
		env.variant | startswith("alpine")
	;
	def os_arches:
		if is_alpine then
			{
				amd64: "x86_64",
				arm32v6: "armhf",
				arm32v7: "armv7",
				arm64v8: "aarch64",
				i386: "x86",
				ppc64le: "ppc64le",
				s390x: "s390x",
			}
		else
			{
				amd64: "amd64",
				arm32v5: "armel",
				arm32v7: "armhf",
				arm64v8: "arm64",
				i386: "i386",
				mips64le: "mips64el",
				ppc64le: "ppc64el",
				s390x: "s390x",
			}
		end
-}}
{{ if is_alpine then ( -}}
FROM alpine:{{ env.variant | ltrimstr("alpine") }}
{{ ) else ( -}}
FROM debian:{{ env.variant }}-slim

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
# ERROR: no download agent available; install curl, wget, or fetch
		curl \
	; \
	rm -rf /var/lib/apt/lists/*
{{ ) end -}}

ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION {{ .version }}

RUN set -eux; \
	\
{{ if is_alpine then ( -}}
	apk add --no-cache --virtual .fetch-deps gnupg; \
{{ ) else ( -}}
	savedAptMark="$(apt-mark showmanual)"; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi; \
{{ ) end -}}
	\
# https://julialang.org/downloads/#julia-command-line-version
# https://julialang-s3.julialang.org/bin/checksums/julia-{{ .version }}.sha256
{{ if is_alpine then ( -}}
	arch="$(apk --print-arch)"; \
{{ ) else ( -}}
	arch="$(dpkg --print-architecture)"; \
{{ ) end -}}
	case "$arch" in \
{{
	[
		.arches
		| to_entries[]
		| select(.key | if is_alpine then startswith("alpine-") else contains("-") | not end)
		| (.key | ltrimstr("alpine-")) as $bashbrewArch
		| (os_arches[$bashbrewArch] // empty) as $osArch
		| .value
		| (
-}}
		{{ $osArch | @sh }}) \
			url={{ .url | @sh }}; \
			sha256={{ .sha256 | @sh }}; \
			;; \
{{
		)
	] | add
-}}
		*) \
			echo >&2 "error: current architecture ($arch) does not have a corresponding Julia binary release"; \
			exit 1; \
			;; \
	esac; \
	\
{{ def wget: if is_alpine then "wget -O" else "curl -fL -o" end -}}
	{{ wget }} julia.tar.gz.asc "$url.asc"; \
	{{ wget }} julia.tar.gz "$url"; \
	\
	echo "$sha256 *julia.tar.gz" | sha256sum {{ if is_alpine then "-w -c" else "--strict --check" end }} -; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$JULIA_GPG"; \
	gpg --batch --verify julia.tar.gz.asc julia.tar.gz; \
	command -v gpgconf > /dev/null && gpgconf --kill all; \
	rm -rf "$GNUPGHOME" julia.tar.gz.asc; \
	\
	mkdir "$JULIA_PATH"; \
	tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	rm julia.tar.gz; \
	\
{{ if is_alpine then ( -}}
	apk del --no-network .fetch-deps; \
{{ ) else ( -}}
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
{{ ) end -}}
	\
# smoke test
	julia --version

CMD ["julia"]