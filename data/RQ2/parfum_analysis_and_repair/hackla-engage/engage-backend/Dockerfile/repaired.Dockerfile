FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -y curl postgresql-contrib netcat && rm -rf /var/lib/apt/lists/*;
ENV LIBRARY_PATH=/lib:/usr/lib
COPY . /engage_backend_service
WORKDIR /engage_backend_service
RUN pip install --no-cache-dir -r requirements.txt
CMD ["scripts/rundev.sh"]