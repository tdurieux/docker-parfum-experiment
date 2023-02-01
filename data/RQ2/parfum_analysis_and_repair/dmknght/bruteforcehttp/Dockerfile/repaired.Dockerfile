FROM debian:latest
# Test with Debian
# Replace by Unbutu if has error

MAINTAINER DmKnght <dmknght@parrotsec.org>

# Install dependencies
# Can run both python2 and 3

RUN apt update && \
    apt install --no-install-recommends python-bs4 python-regex python-lxml -y && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/share/BruteforceHTTP/

RUN cd /usr/local/share/BruteforceHTTP/

ENTRYPOINT ["/bin/bash"]