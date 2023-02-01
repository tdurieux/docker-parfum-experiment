FROM python:3-slim

# Install ruby

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
     ruby && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install xml2rfc
RUN pip install --no-cache-dir xml2rfc

# Install kramdown-rfc2629
RUN gem install kramdown-rfc2629

