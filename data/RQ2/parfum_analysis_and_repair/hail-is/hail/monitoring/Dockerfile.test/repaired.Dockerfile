FROM {{ service_base_image.image }}

COPY monitoring/test/ /test/