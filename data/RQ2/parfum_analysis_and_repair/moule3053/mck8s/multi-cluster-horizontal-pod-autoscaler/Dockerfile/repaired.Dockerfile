FROM python:3.7
RUN pip3 install --no-cache-dir kopf kubernetes pint
COPY utils.py /utils.py
COPY mchpa.py /mchpa.py
CMD kopf run --standalone /mchpa.py
