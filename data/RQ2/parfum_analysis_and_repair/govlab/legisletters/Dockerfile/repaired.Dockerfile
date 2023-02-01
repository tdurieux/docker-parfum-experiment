from elasticsearch

RUN apt-get --fix-missing update --fix-missing && apt-get -yq --no-install-recommends install python-dev python-pip nginx tesseract-ocr imagemagick libyaml-dev && rm -rf /var/lib/apt/lists/*;

COPY legisletters /legisletters
COPY default /etc/nginx/sites-available/default

RUN pip install --no-cache-dir -r /legisletters/requirements.txt
RUN plugin install elasticsearch/elasticsearch-mapper-attachments/2.5.0
