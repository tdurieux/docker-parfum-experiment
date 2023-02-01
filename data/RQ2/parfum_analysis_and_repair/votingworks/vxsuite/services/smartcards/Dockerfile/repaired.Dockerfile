FROM python:3.7.3
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pipenv
RUN apt-get update && apt-get install --no-install-recommends -y \
    libpcsclite-dev \
    libusb-1.0-0-dev \
    pcsc-tools \
    pcscd \
    swig && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
WORKDIR /code
COPY Pipfile Pipfile.lock /code/
RUN pipenv install --dev