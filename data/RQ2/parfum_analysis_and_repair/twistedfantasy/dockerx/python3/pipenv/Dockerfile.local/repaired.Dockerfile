ARG IMAGE
FROM $IMAGE
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

ENV PYTHONUNBUFFERED 1
ENV APP_PATH=/usr/src/ssm/
ENV SCRIPTS_PATH=/usr/src/scripts

RUN mkdir -p $APP_PATH
RUN mkdir -p $SCRIPTS_PATH
WORKDIR $APP_PATH

RUN pip install --no-cache-dir pipenv==2018.11.26

COPY dockerX/ssm/systemuser.py $SCRIPTS_PATH
COPY ssm/Pipfile .
COPY ssm/Pipfile.lock .
RUN pipenv install --system --deploy
COPY ssm/ .

CMD python3 manage.py migrate && python3 $SCRIPTS_PATH/systemuser.py && python3 manage.py runserver 0.0.0.0:8000
