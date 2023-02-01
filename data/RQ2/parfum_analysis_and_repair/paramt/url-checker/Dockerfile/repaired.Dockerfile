FROM python:latest

ADD check_links.py /check_links.py
ADD requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x check_links.py
ENTRYPOINT ["/check_links.py"]
