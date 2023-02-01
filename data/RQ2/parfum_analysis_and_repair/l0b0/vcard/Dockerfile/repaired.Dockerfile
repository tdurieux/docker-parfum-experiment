# Build
FROM python:3.6

ENV PATH /virtualenv/bin:$PATH
ENV VIRTUAL_ENV /virtualenv
RUN mkdir /virtualenv
RUN python -m venv /virtualenv
RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir --requirement requirements.txt

# Run