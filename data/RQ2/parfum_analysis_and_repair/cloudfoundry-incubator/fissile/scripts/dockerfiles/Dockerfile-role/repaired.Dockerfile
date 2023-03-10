FROM {{ index . "base_image" }}

{{ if not .dev }}
MAINTAINER cloudfoundry@suse.example
{{ end }}

LABEL "instance_group"="{{ .instance_group.Name }}"

ADD root /

ENTRYPOINT ["/usr/bin/dumb-init", "/opt/fissile/run.sh"]