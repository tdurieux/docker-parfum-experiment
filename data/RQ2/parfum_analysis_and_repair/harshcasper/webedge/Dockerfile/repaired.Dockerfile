FROM python:3.7

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python setup.py install

CMD ["webedge", "-d", "https://ajitesh13.github.io"]