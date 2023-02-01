FROM    python:3.5

RUN pip install --no-cache-dir nose
RUN     mkdir /envtpl-dev
WORKDIR /envtpl-dev
RUN     git clone https://github.com/andreasjansson/envtpl.git
WORKDIR /envtpl-dev/envtpl
RUN     python setup.py develop
RUN pip install --no-cache-dir -r tests/requirements.txt

CMD     ["nosetests", "tests"]
