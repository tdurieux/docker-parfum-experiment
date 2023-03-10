FROM {{ index . "base_image" }}

{{ range $label, $value := .labels }}
LABEL "{{$label}}"="{{$value}}"
{{ end }}

RUN mkdir -p \
	/var/vcap/data/blobs \
	/var/vcap/data/compile \
	/var/vcap/data/jobs \
	/var/vcap/data/packages \
	/var/vcap/data/sensitive_blobs \
	/var/vcap/data/tmp \
	/var/vcap/jobs \
	/var/vcap/store \
	/var/vcap/store_migration_target \
	/var/vcap/sys/log

ENV RELEASE_NAME {{ .name }}
ENV RELEASE_VERSION {{ .version }}

ADD root /