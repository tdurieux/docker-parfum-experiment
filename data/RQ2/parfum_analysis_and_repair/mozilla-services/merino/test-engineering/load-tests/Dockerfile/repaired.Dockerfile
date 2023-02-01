# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

FROM python:3.9-slim

LABEL maintainer "Raphael Pierzina <raphael@hackebrot.de>"

# Expose ports for the web UI and the locust master