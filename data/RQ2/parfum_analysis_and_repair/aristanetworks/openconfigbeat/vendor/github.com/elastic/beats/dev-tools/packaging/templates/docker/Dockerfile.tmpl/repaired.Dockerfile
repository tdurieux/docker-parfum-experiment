{{- $beatHome := printf "%s/%s" "/usr/share" .BeatName }}
{{- $beatBinary := printf "%s/%s" $beatHome .BeatName }}
{{- $repoInfo := repo }}

FROM {{ .from }}

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="{{ .BeatVendor }}" \
  org.label-schema.name="{{ .BeatName }}" \
  org.label-schema.version="{{ beat_version }}" \
  org.label-schema.url="{{ .BeatURL }}" \
  org.label-schema.vcs-url="{{ $repoInfo.RootImportPath }}" \
  org.label-schema.vcs-ref="{{ commit }}" \
  license="{{ .License }}" \
  description="{{ .BeatDescription }}"

ENV ELASTIC_CONTAINER "true"
ENV PATH={{ $beatHome }}:$PATH

COPY beat {{ $beatHome }}
COPY docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod 755 /usr/local/bin/docker-entrypoint

RUN groupadd --gid 1000 {{ .BeatName }}

RUN mkdir {{ $beatHome }}/data {{ $beatHome }}/logs && \
    chown -R root:{{ .BeatName }} {{ $beatHome }} && \
    find {{ $beatHome }} -type d -exec chmod 0750 {} \; && \
    find {{ $beatHome }} -type f -exec chmod 0640 {} \; && \
    chmod 0750 {{ $beatBinary }} && \
{{- if .linux_capabilities }}
    setcap {{ .linux_capabilities }} {{ $beatBinary }} && \
{{- end }}
{{- range $i, $modulesd := .ModulesDirs }}
    chmod 0770 {{ $beatHome}}/{{ $modulesd }} && \
{{- end }}
    chmod 0770 {{ $beatHome }}/data {{ $beatHome }}/logs

{{- if ne .user "root" }}
RUN useradd -M --uid 1000 --gid 1000 --home {{ $beatHome }} {{ .user }}
{{- end }}
USER {{ .user }}

{{- range $i, $port := .ExposePorts }}
EXPOSE {{ $port }}
{{- end }}

WORKDIR {{ $beatHome }}
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-e"]