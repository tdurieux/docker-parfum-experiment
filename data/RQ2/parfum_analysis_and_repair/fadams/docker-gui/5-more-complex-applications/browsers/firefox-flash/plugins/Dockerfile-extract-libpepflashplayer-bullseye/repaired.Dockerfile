#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM debian:bullseye-slim

# Download the zako Chrome OS recovery image and extract
# libpepflashplayer.so from it.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    # Add the packages used
    apt-get install -y --no-install-recommends \
	wget p7zip-full unzip ca-certificates && \
    # First grok the URL of the zako Chrome OS recovery image from
    # https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf
    IMAGE_URL=$(wget -O - https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf | grep zako | tail -n 1 | cut -d \= -f2) && \
    # The zip name is the part after the last / in the URL
    ZIP_NAME=$(echo "${IMAGE_URL}" | cut -d \/ -f8) && \
    # If we remove the .zip extension we get the bin name
    BIN_NAME=$(echo $ZIP_NAME | rev | cut -d \. -f2- | rev) && \
    # Download the Chrome OS recovery image from the URL and unzip
    cd /mnt && \
    wget -O ${ZIP_NAME} ${IMAGE_URL} && \
    unzip ${ZIP_NAME} && \
    rm ${ZIP_NAME} && \
    # Unpack the binary using p7zip
    7z -y x ${BIN_NAME} -ochromeos && \
    7z -y x ./chromeos/ROOT-A.img -orootfs && \
    mv ./rootfs/opt/google/chrome/pepper . && \
    VERSION=$(cat pepper/pepper-flash.info | grep VERSION= | head -n 1 | cut -d \" -f2) && \
    echo "{\n    \"version\": \"${VERSION}\"\n}" > pepper/manifest.json && \
    # Remove the packages used for extraction from the image
    rm ${BIN_NAME} && \
    rm -rf chromeos && \
    rm -rf rootfs && \
    apt-get clean && \
    apt-get purge -y wget p7zip-full unzip ca-certificates && \
    apt-get autoremove -y && \
    # Display the URL of the Chrome OS image we've just used
    echo "\nUsing Chrome OS image URL:\n${IMAGE_URL}\n" && \
    echo "zip name:\n${ZIP_NAME}\n" && \
    echo "bin name:\n${BIN_NAME}\n" && \
    echo "Version: ${VERSION}\n" && \
	rm -rf /var/lib/apt/lists/*

#-------------------------------------------------------------------------------
# 
# To build the image
# docker build -t extract-libpepflashplayer -f Dockerfile-extract-libpepflashplayer-bullseye .
#
# To run
# docker run --rm extract-libpepflashplayer cat /mnt/pepper/libpepflashplayer.so > libpepflashplayer.so
# docker run --rm extract-libpepflashplayer cat /mnt/pepper/manifest.json > manifest.json
# docker run --rm extract-libpepflashplayer cat /mnt/pepper/pepper-flash.info > pepper-flash.info