FROM python:3.8

# Install CMake for gqlalchemy
RUN apt-get update && \
  apt-get --yes --no-install-recommends install cmake && \
  rm -rf /var/lib/apt/lists/*

# Install packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY dummy.py /app/dummy.py
COPY setup.py /app/setup.py
COPY chatters.csv /app/chatters.csv

WORKDIR /app