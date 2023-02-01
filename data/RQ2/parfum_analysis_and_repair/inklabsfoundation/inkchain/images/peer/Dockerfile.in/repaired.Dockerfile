# Copyright Greg Haskins All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
FROM _BASE_NS_/inkchain-baseos:_BASE_TAG_
ENV INKCHAIN_CFG_PATH /etc/inklabsfoundation/inkchain
RUN mkdir -p /var/inkchain/production $INKCHAIN_CFG_PATH
COPY payload/peer /usr/local/bin
ADD  payload/sampleconfig.tar.bz2 $INKCHAIN_CFG_PATH
RUN apt-get update \
         && apt-get install --no-install-recommends -y vim tree jq \
         && apt-get install --no-install-recommends -y unzip \
         && rm -rf /var/cache/apt && rm -rf /var/lib/apt/lists/*;
CMD ["peer","node","start"]
