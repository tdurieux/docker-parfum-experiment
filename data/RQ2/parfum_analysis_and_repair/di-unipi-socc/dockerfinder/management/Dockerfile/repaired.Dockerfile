FROM python:alpine

RUN mkdir /code

WORKDIR /code

COPY monitor/requirements.txt /code/

# install the requirements
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copy the source code in the /code folder of the container
COPY monitor/ /code
EXPOSE 3002

ENTRYPOINT ["python","/code/app.py" ]

#CMD ["--help"]
