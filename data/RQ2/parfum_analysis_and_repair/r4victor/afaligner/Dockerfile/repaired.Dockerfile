FROM python:3.9-slim

RUN apt update -q \
    && apt install --no-install-recommends -yq espeak \
    libespeak-dev \
    ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -yq gcc && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir numpy==1.21.2
RUN pip install --no-cache-dir pytest==6.2.5

WORKDIR /afaligner
COPY src src
COPY tests tests
COPY LICENSE MANIFEST.in README.md setup.py ./

RUN pip install --no-cache-dir .

WORKDIR /
ENTRYPOINT []
CMD ["bash"]