FROM registry.access.redhat.com/ubi8/ubi:latest AS {{ .BuildContainerName }}
RUN yum install -y {{ .JavaPackageName }} && rm -rf /var/cache/yum

{{- if not .GradlewPresent }}
# install gradle
RUN yum install -y wget unzip && \
    wget https://services.gradle.org/distributions/gradle-{{ .GradleVersion }}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-{{ .GradleVersion }}-bin.zip && \
    rm -rf /tmp/gradle-{{ .GradleVersion }}-bin.zip && rm -rf /var/cache/yum
ENV PATH="$PATH:/opt/gradle/gradle-{{ .GradleVersion }}/bin/"
{{- end }}

{{- if .EnvVariables }}
# environment variables
{{- range $k, $v := .EnvVariables }}
ENV {{$k}} {{$v}}
{{- end}}
{{- end}}

WORKDIR /app

# copy everything, including child modules to do a build using the parent build.gradle
COPY . .

{{- if .GradlewPresent }}
COPY gradlew .
COPY gradle gradle
{{- else }}
# generate the gradle wrapper script
RUN gradle wrapper
{{- end }}

RUN ./gradlew clean assemble {{- range $k, $v := .GradleProperties }} -P{{ $k }}={{ $v }} {{- end }}
