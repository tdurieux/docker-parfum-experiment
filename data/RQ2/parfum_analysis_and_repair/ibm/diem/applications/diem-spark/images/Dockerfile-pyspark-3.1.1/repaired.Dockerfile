# v3.1.1_2021-02-25
FROM quay.io/diem/base-pyspark:3.1.1

LABEL   maintainer=guy_huinen@be.ibm.com \
        org.label-schema.description="Spark Image for Diem" \
        org.label-schema.name="spark" \
        org.label-schema.version=$BUILD_VERSION

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

COPY jars/* /opt/spark/jars/

WORKDIR /opt/

# For spark 3 we need t install them as root and then switch back

USER root

RUN python3.7 -m pip install --upgrade pip

COPY requirements-3.1.1 $HOME
RUN python3.7 -m pip install --prefer-binary -r requirements-3.1.1

RUN chmod -R 775 .

# USER 185