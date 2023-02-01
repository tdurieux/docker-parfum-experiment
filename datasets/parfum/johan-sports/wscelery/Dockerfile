FROM python:3-alpine

MAINTAINER JOHAN Sports <antonis@johan-sports.com>

# Get latest root certificates
RUN apk add --update ca-certificates && update-ca-certificates

# Install required packages
RUN pip install redis wscelery

# Force stdin/stdout/stderr to be completelly unbuffered
ENV PYTHONUNBUFFERED=1

RUN mkdir -p /usr/src/app
COPY tools/run_docker.sh /usr/src/app/run.sh

# Default port
EXPOSE 1337

# Run as non-root user
USER nobody

CMD ["sh", "/usr/src/app/run.sh"]
