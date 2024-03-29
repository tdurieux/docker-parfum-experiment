FROM --platform=${TARGETPLATFORM} liferay/jdk11:latest AS liferay-jdk11

RUN apt-get update && \
	apt-get install --no-install-recommends --yes ffmpeg fonts-dejavu ghostscript imagemagick gifsicle libtcnative-1 && \
	apt-get upgrade --yes && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

FROM liferay-jdk11

ARG LABEL_BUILD_DATE
ARG LABEL_LIFERAY_PATCHING_TOOL_VERSION
ARG LABEL_LIFERAY_TOMCAT_VERSION
ARG LABEL_LIFERAY_VCS_REF
ARG LABEL_NAME
ARG LABEL_VCS_REF
ARG LABEL_VCS_URL
ARG LABEL_VERSION
ARG TARGETPLATFORM

COPY --chown=liferay:liferay liferay /opt/liferay/
COPY resources/usr/local/bin/* /usr/local/bin/

ENTRYPOINT ["tini", "--", "/usr/local/bin/liferay_entrypoint.sh"]

ENV JPDA_ADDRESS=8000

ENV LIFERAY_DISABLE_TRIAL_LICENSE=false
ENV LIFERAY_HOME=/opt/liferay
ENV LIFERAY_JPDA_ENABLED=false
ENV LIFERAY_JVM_OPTS=
ENV LIFERAY_PID="${LIFERAY_HOME}/liferay.pid"
ENV LIFERAY_PRODUCT_NAME="${LABEL_NAME}"
ENV LIFERAY_THREAD_DUMP_DIRECTORY="${LIFERAY_HOME}/data/logs"
ENV LIFERAY_THREAD_DUMP_PROBE_ENABLED="false"

ENV LIFERAY_CONFIGURATION_PERIOD_OVERRIDE_PERIOD_COM_PERIOD_LIFERAY_PERIOD_DOCUMENT_PERIOD_LIBRARY_PERIOD_PREVIEW_PERIOD_AUDIO_PERIOD_INTERNAL_PERIOD_CONFIGURATION_PERIOD__UPPERCASED__UPPERCASEL__UPPERCASEA_UDIO_UPPERCASEF__UPPERCASEF__UPPERCASEM__UPPERCASEP__UPPERCASEE__UPPERCASEG__UPPERCASEA_UDIO_UPPERCASEC_ONVERTER_UPPERCASEC_ONFIGURATION_UNDERLINE_ENABLED='"true"'
ENV LIFERAY_CONFIGURATION_PERIOD_OVERRIDE_PERIOD_COM_PERIOD_LIFERAY_PERIOD_DOCUMENT_PERIOD_LIBRARY_PERIOD_VIDEO_PERIOD_INTERNAL_PERIOD_CONFIGURATION_PERIOD__UPPERCASED__UPPERCASEL__UPPERCASEV_IDEO_UPPERCASEF__UPPERCASEF__UPPERCASEM__UPPERCASEP__UPPERCASEE__UPPERCASEG__UPPERCASEV_IDEO_UPPERCASEC_ONVERTER_UPPERCASEC_ONFIGURATION_UNDERLINE_ENABLED='"true"'
ENV LIFERAY_IMAGEMAGICK_PERIOD_ENABLED=true
ENV LIFERAY_IMAGEMAGICK_PERIOD_GLOBAL_PERIOD_SEARCH_PERIOD_PATH_OPENBRACKET_UNIX_CLOSEBRACKET_="/usr/bin:/usr/share/fonts/"
ENV LIFERAY_MODULE_PERIOD_FRAMEWORK_PERIOD_PROPERTIES_PERIOD_OSGI_PERIOD_CONSOLE=0.0.0.0:11311
ENV LIFERAY_SETUP_PERIOD_WIZARD_PERIOD_ADD_PERIOD_SAMPLE_PERIOD_DATA=false
ENV LIFERAY_SETUP_PERIOD_WIZARD_PERIOD_ENABLED=false
ENV LIFERAY_TERMS_PERIOD_OF_PERIOD_USE_PERIOD_REQUIRED=false
ENV LIFERAY_USERS_PERIOD_REMINDER_PERIOD_QUERIES_PERIOD_ENABLED=false

EXPOSE 8000 8009 8080 11311

HEALTHCHECK \
	--interval=5s \
	--start-period=25s \
	--timeout=1m \
	CMD curl -fsS "http://localhost:8080/c/portal/layout" || exit 1

LABEL com.liferay.patching-tool-version="${LABEL_LIFERAY_PATCHING_TOOL_VERSION}"
LABEL com.liferay.tomcat.version="${LABEL_LIFERAY_TOMCAT_VERSION}"
LABEL com.liferay.vcs-ref="${LABEL_LIFERAY_VCS_REF}"
LABEL org.label-schema.build-date="${LABEL_BUILD_DATE}"
LABEL org.label-schema.name="${LABEL_NAME}"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-ref="${LABEL_VCS_REF}"
LABEL org.label-schema.vcs-url="${LABEL_VCS_URL}"
LABEL org.label-schema.vendor="Liferay, Inc."
LABEL org.label-schema.version="${LABEL_VERSION}"

RUN ln -fs /opt/liferay/* /home/liferay

USER liferay:liferay

WORKDIR /opt/liferay