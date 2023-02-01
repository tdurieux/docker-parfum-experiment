FROM python:3.8-slim-buster
VOLUME /result

RUN apt update && apt install --no-install-recommends -y git file gpg && pip install --no-cache-dir git+https://github.com/niess/python-appimage && rm -rf /var/lib/apt/lists/*;

ADD . /xxh
RUN mkdir -p /result

WORKDIR /xxh/appimage
RUN echo '/xxh' > requirements.txt && cat pre-requirements.txt >> requirements.txt

WORKDIR /xxh
RUN python -m python_appimage build app -p 3.8 /xxh/appimage
CMD cp /xxh/xxh-x86_64.AppImage /result && ls -sh1 /result
