FROM python:3.10-slim
RUN apt-get update && apt -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pytest pytest-watch pytest-testmon
RUN pip install --no-cache-dir matplotlib pandas scikit-learn

RUN mkdir /src
WORKDIR /src
