FROM python:3.6-slim

RUN apt-get clean \
    && apt-get -y update

RUN apt-get -y --no-install-recommends install \
    nginx \
    python3-dev \
    build-essential && rm -rf /var/lib/apt/lists/*;

COPY . /rafMetrics
WORKDIR /rafMetrics

# Install requirements for Python modules
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5000:5000

ENV PYTHONPATH="/rafMetrics"
ENTRYPOINT ["python3", "./Login/app.py"]

# For development purpose only
# ENTRYPOINT ["tail", "-f", "/dev/null"]

