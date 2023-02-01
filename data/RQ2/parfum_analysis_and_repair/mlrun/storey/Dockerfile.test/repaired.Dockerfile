FROM python:3.8-slim
RUN apt-get update && apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip
WORKDIR /storey
COPY . .
RUN python -m pip install -r requirements.txt -r dev-requirements.txt
RUN make test
