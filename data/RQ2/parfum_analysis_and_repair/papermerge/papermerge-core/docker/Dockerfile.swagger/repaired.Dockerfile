FROM swaggerapi/swagger-ui

ENV SWAGGER_JSON="/schema.yml"

COPY docker/openapi-schema.yml /schema.yml

# HTTP static content is exposed on port 8080
# Example of usage:
#
# docker run -p 9000:8080 papermerge/swagger-ui:2.1.0-alpha8