FROM {{ service_base_image.image }}

COPY benchmark-service/test/ /test/