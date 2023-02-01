FROM python

RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
ENV PATH "/root/.poetry/bin:$PATH"

RUN mkdir /build
WORKDIR /build
COPY pyproject.toml poetry.lock README.md ./
RUN mkdir /sweat
COPY sweat ./sweat

RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir jupyter

RUN mkdir /src/
WORKDIR /src/docs/docs

CMD jupyter notebook --ip=0.0.0.0  --port=8888 --allow-root --NotebookApp.token='' --NotebookApp.password=''
