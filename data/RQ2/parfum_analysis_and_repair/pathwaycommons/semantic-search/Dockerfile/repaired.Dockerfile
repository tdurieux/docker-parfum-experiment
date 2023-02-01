FROM tiangolo/python-machine-learning:cuda9.1-python3.7

ADD . /

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -e .

CMD ["uvicorn", "semantic_search.main:app", "--host", "0.0.0.0"]
