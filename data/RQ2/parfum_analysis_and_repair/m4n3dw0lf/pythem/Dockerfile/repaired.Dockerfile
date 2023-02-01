FROM python:2.7

WORKDIR /usr/src/app

COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y build-essential python-dev tcpdump python-capstone libnetfilter-queue-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN python setup.py sdist

RUN pip install --no-cache-dir dist/*

CMD [ "pythem" ]

