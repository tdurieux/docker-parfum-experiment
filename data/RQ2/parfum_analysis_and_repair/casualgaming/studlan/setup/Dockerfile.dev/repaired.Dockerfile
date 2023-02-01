FROM python:2.7

WORKDIR /srv/studlan

# Install requirements
COPY requirements/ requirements/
RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y gettext && \
rm -rf /var/lib/apt/lists/* && \
python -m pip install --no-cache-dir -r requirements/development.txt --upgrade

ENTRYPOINT ["/bin/bash"]
