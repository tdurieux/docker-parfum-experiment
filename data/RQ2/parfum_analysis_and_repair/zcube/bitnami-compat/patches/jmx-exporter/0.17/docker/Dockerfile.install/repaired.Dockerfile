ENV JMX_EXPORTER_VERSION {{{VERSION}}}
RUN install_packages curl tar \
 && mkdir -p /opt/bitnami/jmx-exporter \
 && curl -f -L -o /opt/bitnami/jmx-exporter/jmx_prometheus_httpserver.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/${JMX_EXPORTER_VERSION}/jmx_prometheus_httpserver-${JMX_EXPORTER_VERSION}-jar-with-dependencies.jar \
 && curl -f -L -o /opt/bitnami/jmx-exporter/jmx_prometheus_javaagent.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar \
 && curl -f -L -o /opt/bitnami/jmx-exporter/LICENSE-2.0.txt https://www.apache.org/licenses/LICENSE-2.0.txt \
 && curl -f -L -o parent-${JMX_EXPORTER_VERSION}.tar.gz https://github.com/prometheus/jmx_exporter/archive/refs/tags/parent-${JMX_EXPORTER_VERSION}.tar.gz \
 && mkdir -p /opt/bitnami/jmx-exporter/example_configs \
 && tar -C /opt/bitnami/jmx-exporter/example_configs --strip-components=2 -zxvf parent-${JMX_EXPORTER_VERSION}.tar.gz jmx_exporter-parent-${JMX_EXPORTER_VERSION}/example_configs && rm parent-${JMX_EXPORTER_VERSION}.tar.gz
