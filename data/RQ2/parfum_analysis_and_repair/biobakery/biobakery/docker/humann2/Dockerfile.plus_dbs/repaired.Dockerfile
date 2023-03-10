# Use the biobakery humann2 image
FROM biobakery/humann2:2.8.0

# Install humann2 databases
RUN mkdir /opt/dbs && \
    humann2_databases --download chocophlan full /opt/dbs/ && \
    humann2_databases --download uniref uniref90_diamond /opt/dbs/ && \
    humann2_databases --download utility_mapping full /opt/dbs/

RUN pip install --no-cache-dir boto3 anadama2==0.6.7
