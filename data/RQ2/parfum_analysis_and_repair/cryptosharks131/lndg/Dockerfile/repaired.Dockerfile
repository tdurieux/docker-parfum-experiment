FROM python:3
ENV PYTHONUNBUFFERED 1
RUN git clone https://github.com/cryptosharks131/lndg.git /lndg
WORKDIR /lndg
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir supervisor whitenoise