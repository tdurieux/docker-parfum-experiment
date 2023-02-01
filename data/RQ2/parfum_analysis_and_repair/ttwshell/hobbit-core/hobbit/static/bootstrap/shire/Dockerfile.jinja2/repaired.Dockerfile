FROM python:3.6.5

ENV FLASK_APP=app/run.py

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y \
    zip sshpass && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip -i https://pypi.doubanio.com/simple
RUN pip install --no-cache-dir flake8 pytest pytest-cov gunicorn gevent

RUN mkdir /app
WORKDIR /app

# COPY ./Pipfile /app
# COPY ./Pipfile.lock /app
COPY ./requirements.txt /app

# RUN pip install -i https://pypi.doubanio.com/simple --no-cache-dir pipenv \
#     && pipenv install --system --deploy --dev
RUN pip install --no-cache-dir -r requirements.txt

