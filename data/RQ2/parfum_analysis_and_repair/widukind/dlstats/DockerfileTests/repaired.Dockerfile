FROM widukind/docker-base

ADD . /code/

RUN pip install --no-cache-dir -U -r requirements.txt \
	&& pip install --no-cache-dir -U -r requirements-tests.txt \
    && pip install --no-cache-dir --no-deps -e .
