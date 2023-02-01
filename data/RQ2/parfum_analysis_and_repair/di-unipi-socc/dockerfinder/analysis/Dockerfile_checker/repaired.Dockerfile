#scanner image
FROM python:alpine

RUN mkdir /code

WORKDIR /code

COPY  pyFinder/requirements.txt /code/
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY pyFinder/ /code

ENTRYPOINT ["python","/code/entryChecker.py"]
CMD ["--help"]
