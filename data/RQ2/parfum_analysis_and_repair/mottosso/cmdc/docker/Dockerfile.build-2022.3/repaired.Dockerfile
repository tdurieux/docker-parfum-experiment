FROM aswf/ci-base:2021.6

# Download devkit
ENV DEVKIT "https://autodesk-adn-transfer.s3-us-west-2.amazonaws.com/ADN+Extranet/M%26E/Maya/devkit+2022/Autodesk_Maya_2022_3_Update_DEVKIT_Linux.tgz"
RUN wget $DEVKIT -O /tmp/devkit.tgz && \
    mkdir -p /usr/autodesk && \
    tar -xvf /tmp/devkit.tgz -C /usr/autodesk/ && \
    rm /tmp/devkit.tgz