FROM {{ docker_test_image_alpine }}
ENV INSTALL_PATH /newdata
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH