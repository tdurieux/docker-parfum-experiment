FROM debian

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends cmake && pip-python && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir face_recognition
