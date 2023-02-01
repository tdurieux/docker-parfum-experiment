FROM metabrainz/python:3.7-20210115

RUN mkdir /data
RUN mkdir /code
WORKDIR /code

# Python dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                       build-essential \
                       git && rm -rf /var/lib/apt/lists/*;
COPY . /code/
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements_dev.txt

CMD find . -iname "*.py" | xargs pylint -j 4 | tee /data/pylint.out
