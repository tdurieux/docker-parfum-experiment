ARG IMAGE_NAME
ARG IMAGE_VERSION

FROM ${IMAGE_NAME}:${IMAGE_VERSION}

RUN pip install --no-cache-dir --upgrade pip setuptools

WORKDIR /opt/sect

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY requirements-tests.txt .
RUN pip install --no-cache-dir -r requirements-tests.txt

COPY README.md .
COPY pytest.ini .
COPY setup.py .
COPY sect sect
COPY tests tests
