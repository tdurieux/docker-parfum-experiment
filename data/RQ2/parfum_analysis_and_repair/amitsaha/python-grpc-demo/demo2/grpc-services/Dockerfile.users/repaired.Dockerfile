FROM python:3.6-jessie
RUN set -e; \
	apt-get update ; \
    apt-get install -y --no-install-recommends \
		gcc \
        g++ \
	; rm -rf /var/lib/apt/lists/*; \
    pip install --no-cache-dir --upgrade pip; \
    pip install --no-cache-dir grpcio==1.6.3 grpcio-tools==1.6.3
ADD protos/gen-py /protos/gen-py
ADD users/server /server

# Add the client code strictly for development
# purposes
ADD users/client /client
WORKDIR /server
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 50051
VOLUME /server
CMD PYTHONPATH=/:/protos/gen-py python3 server.py
