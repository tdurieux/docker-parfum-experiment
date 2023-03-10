FROM python:3.8

# Install CMake
RUN apt-get update && \
  apt-get --yes --no-install-recommends install cmake && \
  rm -rf /var/lib/apt/lists/*

# Install packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY app.py /app/app.py
COPY import-data /app/import-data
WORKDIR /app

ENV FLASK_ENV=development
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENTRYPOINT ["python3", "app.py", "--populate"]