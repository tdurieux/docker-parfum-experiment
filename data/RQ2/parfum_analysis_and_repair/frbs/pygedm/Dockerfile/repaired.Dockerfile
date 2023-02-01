FROM python:3.8-slim-buster
RUN apt-get update && apt-get install --no-install-recommends build-essential git f2c pkg-config -y && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements_test.txt
RUN pip3 install --no-cache-dir .




