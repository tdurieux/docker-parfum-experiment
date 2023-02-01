FROM python:2-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/Hadesy2k/sqliv.git
WORKDIR /sqliv
RUN pip install --no-cache-dir -r requirements.txt && python setup.py -i

ENTRYPOINT ["python","sqliv.py"]
CMD ["--help"]