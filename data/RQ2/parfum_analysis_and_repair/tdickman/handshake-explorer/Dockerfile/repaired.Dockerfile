FROM        python:3.6

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt update && apt install --no-install-recommends -y nodejs libunbound-dev && rm -rf /var/lib/apt/lists/*

WORKDIR     /app
RUN pip install --no-cache-dir pipenv
ADD         Pipfile* /tmp/
RUN         cd /tmp && pipenv install --system --deploy

ADD			hsdexplorer/hsdbin/package.json /app/hsdbin/
RUN cd hsdbin && npm install && npm cache clean --force;

ADD         ./hsdexplorer/ /app/
RUN	    	COLLECTSTATIC=1 echo 'yes' | python manage.py collectstatic; python manage.py compilescss; unset COLLECTSTATIC

ENTRYPOINT  ["gunicorn", "--bind", "0.0.0.0:8000", "--log-level", "debug", "hsdexplorer.wsgi"]
