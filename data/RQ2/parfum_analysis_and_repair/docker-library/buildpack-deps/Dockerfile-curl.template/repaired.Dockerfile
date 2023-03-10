FROM {{ env.dist }}:{{ env.codename }}

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
{{ if env.codename == "xenial" then ( -}}
		apt-transport-https \
{{ ) else "" end -}}
		ca-certificates \
		curl \
		netbase \
		wget \
{{ if env.dist == "ubuntu" then ( -}}
# https://bugs.debian.org/929417
		tzdata \
{{ ) else "" end -}}
	; \
	rm -rf /var/lib/apt/lists/*

RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi