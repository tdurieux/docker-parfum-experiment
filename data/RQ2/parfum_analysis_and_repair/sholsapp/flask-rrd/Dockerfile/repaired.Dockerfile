FROM ubuntu
RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install \
    librrd-dev \
    libxml2-dev \
    libglib2.0 \
    libcairo2-dev \
    libpango1.0-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /build/
COPY . /build/
RUN pip3 install --no-cache-dir -r requirements.txt && python3 setup.py install
EXPOSE 5000
CMD ["./manage.py", "runserver"]
