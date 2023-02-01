FROM python:3.7

RUN mkdir govuk
WORKDIR govuk

COPY requirements-freeze.txt .
COPY tf_ranking_libsvm.py .
COPY train.sh .

RUN pip install --no-cache-dir -r requirements-freeze.txt
RUN chmod +x train.sh

ENTRYPOINT ["./train.sh"]
