############################################################
# Dockerfile to build Genropy-pg container images
# Based on genropy/genropy
############################################################

FROM public.ecr.aws/genropy/genropy

RUN apk update \
  && apk add --no-cache py3-psycopg2