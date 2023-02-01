FROM python:3.8
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y netcat-traditional && rm -rf /var/lib/apt/lists/*;
WORKDIR /code
ADD ./docker/requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir -p /data/data_files /data/tf_idf /data/model_pickles /data/code_books
EXPOSE 8000
