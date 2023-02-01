FROM python:3.7.7-slim AS base

FROM base AS builder

# Build dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# The repository itself
RUN mkdir -p /tmp/agora
COPY . /tmp/agora
WORKDIR /tmp/agora
RUN git clean -d -f
RUN git clean -X -f
RUN rm -rf .git

# Compile all Python files to speed things up
RUN python -m compileall .

# Trick to only keep the files we need and make the image smaller
FROM base AS prod
COPY --from=builder /tmp/agora /opt/agora
COPY --from=builder /usr/local /usr/local

# Test the image
FROM prod AS test
WORKDIR /opt/agora
RUN ./checkAgoraIntegrity.sh

FROM prod
