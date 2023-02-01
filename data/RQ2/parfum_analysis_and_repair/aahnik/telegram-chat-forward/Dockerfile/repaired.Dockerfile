FROM python:3.9
ENV VENV_PATH="/venv"
ENV PATH="$VENV_PATH/bin:$PATH"
WORKDIR /app
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends ffmpeg tesseract-ocr -y && \
    apt-get autoclean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade poetry
RUN python -m venv /venv
COPY . .
RUN poetry build && \
    /venv/bin/pip install --upgrade pip wheel setuptools &&\
    /venv/bin/pip install dist/*.whl
CMD tgcf --loud
