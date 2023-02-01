FROM python:3.6
ADD ./src /smtpd
WORKDIR /smtpd
RUN pip install --no-cache-dir -r requirements.txt
CMD python -u app.py

