ARG ARCH=armv7hf
ARG VERSION=3.5
ARG UBUNTU_VERSION=20.04
ARG REPO=axisecp
ARG SDK=acap-sdk

FROM ${REPO}/${SDK}:${VERSION}-${ARCH}-ubuntu${UBUNTU_VERSION}

# Download model
WORKDIR /opt/app/model
RUN curl -f -o mobilenet_v2_1.0_224_quant.tgz https://download.tensorflow.org/models/tflite_11_05_08/mobilenet_v2_1.0_224_quant.tgz && \
    tar -xvf mobilenet_v2_1.0_224_quant.tgz && \
    curl -f -L -o mobilenet_v2_1.0_224_quant_edgetpu.tflite https://github.com/google-coral/edgetpu/raw/master/test_data/mobilenet_v2_1.0_224_quant_edgetpu.tflite && \
    curl -f -L -o imagenet_labels.txt https://github.com/google-coral/edgetpu/raw/master/test_data/imagenet_labels.txt && rm mobilenet_v2_1.0_224_quant.tgz

# Copy the library to application folder
WORKDIR /opt/app
COPY ./app .

ARG CHIP=
# Building the ACAP application
RUN if [ "$CHIP" = cpu ] || [ "$CHIP" = artpec8 ]; then \
        cp /opt/app/manifest.json.${CHIP} /opt/app/manifest.json && \
        . /opt/axis/acapsdk/environment-setup* && acap-build . \
        -a 'model/mobilenet_v2_1.0_224_quant.tflite' -a 'model/imagenet_labels.txt' ; \
    elif [ "$CHIP" = edgetpu ]; then \
        cp /opt/app/manifest.json.${CHIP} /opt/app/manifest.json && \
        . /opt/axis/acapsdk/environment-setup* && acap-build . \
        -a 'model/mobilenet_v2_1.0_224_quant_edgetpu.tflite' -a 'model/imagenet_labels.txt' ; \
    else \
        printf "Error: '%s' is not a valid value for the CHIP variable\n", "$CHIP"; \
        exit 1; \
    fi
