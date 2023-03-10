ARG BASE_IMAGE=ghcr.io/yue9944882/crd-model-gen-base:v1.0.0
FROM ${BASE_IMAGE}
# TODO: move this to kubernetes-client group after the permission issue fixed

ARG GENERATION_XML_FILE

# Copy required files
COPY openapi-generator/generate_client_in_container.sh /generate_client.sh
COPY preprocess_spec.py /
COPY custom_objects_spec.json /
COPY ${GENERATION_XML_FILE} /generation_params.xml

ENTRYPOINT ["mvn-entrypoint.sh", "/generate_client.sh"]