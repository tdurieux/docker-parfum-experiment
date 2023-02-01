FROM python:3.7
WORKDIR /
COPY . /
RUN pip install --no-cache-dir pipenv
RUN pipenv install
RUN pipenv run pip freeze > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "main.py"]
