FROM jrottenberg/ffmpeg:snapshot-alpine AS builder

RUN apk add --no-cache python3 build-base python3-dev py3-aiohttp curl

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM builder

COPY monitor.py .

ENTRYPOINT './monitor.py'
CMD ['./monitor.py']
