FROM python:3.7

COPY requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt; exit 0
RUN pip install --no-cache-dir gunicorn

COPY app app
COPY run.py boot.sh  ./

RUN chmod +x boot.sh

ENTRYPOINT ["./boot.sh"]