FROM python:3.7
WORKDIR /project
ENV PYTHONPATH /project
RUN pip install --no-cache-dir pipenv
COPY Pipfile* /project/
RUN pipenv lock --requirements > requirements.txt
RUN pip install --no-cache-dir -r /project/requirements.txt
COPY . .
ENTRYPOINT ["dev/entrypoint.sh"]