FROM python

RUN pip install --no-cache-dir numpy cython sklearn lightgbm catboost

COPY . /project
WORKDIR /project