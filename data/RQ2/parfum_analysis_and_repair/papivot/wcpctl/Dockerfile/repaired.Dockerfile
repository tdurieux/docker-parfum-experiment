FROM python:3

WORKDIR /app
COPY requirements.txt /app/requirements.txt
COPY wcpctl.py /app/wcpctl.py
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "./wcpctl.py" ]