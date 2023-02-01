FROM python:3.6.1
ADD requirements.txt .
RUN pip install --no-cache-dir pip==20.2.4
RUN pip install --no-cache-dir --upgrade setuptools
run pip install --no-cache-dir wheel==0.35.1
RUN pip install --no-cache-dir --trusted-host files.pythonhosted.org -r requirements.txt
#RUN apt-get update
# add API tests source code
COPY . .

CMD ["/bin/bash", "startTests.sh"]
