#
#------------------------------------------------------------------------
# Trakt.tv tools
#
# Copyright 2016-2021 xbgmsharp <xbgmsharp@gmail.com>. All Rights Reserved.
# License:  GNU General Public License version 3 or later; see LICENSE.txt
# Website:  https://trakt.tv, https://github.com/xbgmsharp/trakt
#------------------------------------------------------------------------
#

FROM python:alpine

RUN apk update && apk add --no-cache git

WORKDIR /trakt
COPY . .

RUN pip install --no-cache-dir requests simplejson
