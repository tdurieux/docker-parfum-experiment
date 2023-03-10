# Copyright (c) 2017 Wind River Systems Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM alpine:3.9 as builder

RUN apk add --update --no-cache python3 make bash openssl ca-certificates gcc python3-dev musl-dev curl && \
    addgroup -g 1000 toaster && \
    adduser -h /home/toaster -u 1000 -G toaster -s /bin/bash -D toaster

COPY Makefile MANIFEST.in setup.py /home/toaster/

COPY toaster_aggregator /home/toaster/toaster_aggregator

COPY docker-production.ini /home/toaster/dist/

RUN chown -R toaster:toaster /home/toaster

USER toaster

# Generate the license report for the python packages used by toaster_aggregator
RUN cd /home/toaster/ && make dist/toaster_aggregator

USER root

RUN cd /home/toaster && curl -f --silent --remote-name https://raw.githubusercontent.com/WindRiver-OpenSourceLabs/license-report/master/generate_report.sh && \
    apk update && bash generate_report.sh --pip /home/toaster/.venv/bin/pip > /home/toaster/report && rm -rf /var/cache/apk/*

FROM alpine:3.9

COPY --from=builder /home/toaster/report /license-report/report
COPY --from=builder /home/toaster/generate_report.sh /license-report/generate_report.sh

# Append alpine package data to the python package data
RUN apk add --update python3 tini && \
    cd /license-report && \
    sh /license-report/generate_report.sh -a report >> report && \
    rm -rf /var/cache/apk/* && \
    addgroup -g 1000 toaster && \
    adduser -h /home/toaster -u 1000 -G toaster -s /bin/ash -D toaster

EXPOSE 6543

COPY --from=builder /home/toaster/dist/ /usr/local/bin/

USER toaster

ENTRYPOINT [ "/sbin/tini" ]

CMD [ "/usr/local/bin/toaster_aggregator", "--paste", "/usr/local/bin/docker-production.ini" ]
