{{- $knative := index .Packages "knative" -}}

FROM {{ .From }}

ENV C2D_RELEASE {{ $knative.Version }}