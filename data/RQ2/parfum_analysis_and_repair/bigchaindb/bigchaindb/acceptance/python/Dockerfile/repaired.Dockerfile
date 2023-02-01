FROM python:3.6.3

RUN mkdir -p /src
RUN pip install --no-cache-dir --upgrade \
	pycco \
	websocket-client~=0.47.0 \
	pytest~=3.0 \
	bigchaindb-driver~=0.6.2 \
	blns
