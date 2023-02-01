FROM python:3.10

RUN apt-get update && apt-get install --no-install-recommends -y \
	python3-setuptools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip==21.2.4

WORKDIR /monitor

COPY . .

RUN chmod +x run.sh

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["/monitor/run.sh"]