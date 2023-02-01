#########################################
# Python3 flask server for REST API backend

FROM pdonorio/py3kbase
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@gmail.com>"

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    # nginx for uwsgi
    nginx \
    # CLEAN
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log && rm -rf /var/lib/apt/lists/*;

# Install the micro framework and important plugins
RUN pip install --no-cache-dir --upgrade pip \

    nose nose2 cov-core \

	coverage \

	Flask==0.12 \

    git+https://github.com/flask-restful/flask-restful@master \

	flask-sqlalchemy flask-cors pyopenssl flask-oauthlib \

    bravado_core \



    redis \
    celery \
    elasticsearch elasticsearch-dsl \

    uwsgi uwsgitop \


	pyjwt

RUN mkdir -p /code
WORKDIR /code
