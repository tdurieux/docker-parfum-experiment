From python:3.6
ARG KEARCH_COMMON_BRANCH="dev"

RUN pip install --no-cache-dir flask pytest
RUN git clone https://github.com/kearch/kearch
RUN cd /kearch/packages/kearch_common && git checkout $KEARCH_COMMON_BRANCH && pip install --no-cache-dir -e .

COPY . /kearch/packages/sp-query-processor
WORKDIR /kearch/packages/sp-query-processor

CMD ["python", "-u", "flask_main.py"]
