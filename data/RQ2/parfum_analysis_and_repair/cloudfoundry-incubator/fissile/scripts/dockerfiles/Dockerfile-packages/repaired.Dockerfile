FROM {{ index . "base_image" }}

ADD packages-src /var/vcap/packages/.src/

LABEL {{ index . "fissile_version" }}
{{ range $label, $value := .labels }}
LABEL "{{$label}}"="{{$value}}"
{{ end }}
{{ if .packages }}
LABEL {{ range .packages }} "fingerprint.{{.Fingerprint}}"="{{.Name}}" {{ end }}
{{ end }}