FROM alpine:3.10.2

# Install some system utilities for Python to use
RUN apk update && apk upgrade && apk add --no-cache gcc musl-dev libc-dev libc6-compat linux-headers build-base libffi-dev openssl-dev openssh-client git

# Install Node, Make, Python and Git
RUN apk add --no-cache --update make git bash python3 python3-dev
COPY pip-reqs.txt /
RUN cat pip-reqs.txt
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r /pip-reqs.txt
