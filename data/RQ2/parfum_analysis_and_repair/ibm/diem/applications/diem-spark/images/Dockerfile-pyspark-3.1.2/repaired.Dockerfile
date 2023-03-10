# v3.1.2_2021-06-07
FROM quay.io/diem/base-pyspark:3.1.2 as base

LABEL   maintainer=guy_huinen@be.ibm.com \
        org.label-schema.description="Spark Image for Diem" \
        org.label-schema.name="spark" \
        org.label-schema.version=$BUILD_VERSION

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

COPY jars/* /opt/spark/jars/

USER root

RUN apt-get install --no-install-recommends -y python3-venv && rm -rf /var/lib/apt/lists/*;

# For spark 3 we need t install them as root and then switch back

FROM base

ENV VIRTUAL_ENV=/opt/venv

RUN python3 -m venv $VIRTUAL_ENV

COPY requirements-3.1.2.txt $HOME

RUN python3.7 -m pip install --upgrade pip &&\
    python3.7 -m pip install --prefer-binary -r requirements-3.1.2.txt

RUN chmod -R 775 .

# USER 185


