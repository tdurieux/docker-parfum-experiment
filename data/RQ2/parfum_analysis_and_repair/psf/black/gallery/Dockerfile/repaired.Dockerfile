FROM python:3.8.2-slim

# note: a single RUN to avoid too many image layers being produced
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends git apt-utils -y \
 && git config --global user.email "black@psf.github.com" \
 && git config --global user.name "Gallery/Black" && rm -rf /var/lib/apt/lists/*;

COPY gallery.py /
ENTRYPOINT ["python", "/gallery.py"]
