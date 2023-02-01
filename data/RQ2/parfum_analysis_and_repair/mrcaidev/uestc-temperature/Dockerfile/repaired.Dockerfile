FROM python:3-slim

WORKDIR /app

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pipenv

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

RUN pipenv install

COPY . .

CMD [ "pipenv", "run", "python", "-u", "src/main.py" ]
