FROM {{ base_image.image }}

RUN hail-apt-get-install liblz4-dev maven