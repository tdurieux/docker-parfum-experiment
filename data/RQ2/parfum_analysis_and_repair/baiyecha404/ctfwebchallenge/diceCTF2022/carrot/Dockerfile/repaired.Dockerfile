FROM python:3.10.2-bullseye

RUN mkdir /code
WORKDIR /code
COPY code/ /code

RUN apt update && \
	apt install --no-install-recommends -y libleveldb-dev && \
	rm -rf /var/lib/apt/lists/* && \
	pip install --no-cache-dir -r requirements.txt

CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0"]
