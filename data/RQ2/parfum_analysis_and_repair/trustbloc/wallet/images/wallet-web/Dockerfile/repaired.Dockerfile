# Copyright SecureKey Technologies Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

FROM nginx:latest
LABEL org.opencontainers.image.source https://github.com/trustbloc/wallet

COPY build/bin/wallet-web/ /usr/share/nginx/www/
COPY images/wallet-web/templates/ /etc/nginx/templates/

# defines environment variables
# NOTE: nginx will not start without them since we are using them in templates/default.conf.template