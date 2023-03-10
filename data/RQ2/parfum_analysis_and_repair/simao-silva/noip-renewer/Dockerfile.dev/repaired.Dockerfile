FROM python:3.10.5-alpine@sha256:97725c6081f5670080322188827ef5cd95325b8c69e401047f0fa0c21910042d

RUN apk add --no-cache gcc libc-dev libffi-dev && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --user selenium googletrans=="3.1.0a0" requests


FROM python:3.10.5-alpine@sha256:97725c6081f5670080322188827ef5cd95325b8c69e401047f0fa0c21910042d

RUN apk add --no-cache chromium chromium-chromedriver && \
    rm -rf /var/cache/apk/* /tmp/* /usr/share/doc

COPY --from=0 /root/.local /root/.local

ENV PATH=/root/.local/bin:$PATH

ADD renew.py .

ENTRYPOINT ["python3", "renew.py"]