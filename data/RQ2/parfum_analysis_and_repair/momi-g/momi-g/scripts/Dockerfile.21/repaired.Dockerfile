FROM quay.io/vgteam/vg:v1.21.0

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/MoMI-G/MoMI-G/" \
      org.label-schema.schema-version="1.0.0-rc1"

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y \
		samtools ruby rsync bedtools gawk \
	&& rm -rf /var/lib/apt/lists/*

COPY . .

#RUN yarn install && yarn build

ENV PATH $PATH:/usr/src/app/

ENTRYPOINT ["/usr/src/app/vcf2xg.sh"]

