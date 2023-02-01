FROM apache/skywalking-oap-server:9.1.0

RUN rm /skywalking/config/log4j2.xml
ADD ./log4j2.xml /skywalking/config/log4j2.xml

ADD ./spp-processor-*.jar /skywalking/oap-libs/

RUN printf "\nspp-live-instrument:\n  selector: \${SPP_LIVE_INSTRUMENT:default}\n  default:\n" \
    >> /skywalking/config/application.yml

RUN printf "\nexporter:\n  selector: exporter\n  exporter:\n" \
    >> /skywalking/config/application.yml

ADD ./ui-initialized-templates /skywalking/config/ui-initialized-templates
