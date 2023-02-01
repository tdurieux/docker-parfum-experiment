FROM kleeweb-worker

RUN apt-get update && apt-get install --no-install-recommends -y sudo docker.io && rm -rf /var/lib/apt/lists/*;

WORKDIR /worker

RUN pip install --no-cache-dir flake8

CMD flake8 --extend-ignore=E722 --max-complexity 12 . \
  && python -m unittest discover -s ./worker/tests/ -p 'test_*.py'
