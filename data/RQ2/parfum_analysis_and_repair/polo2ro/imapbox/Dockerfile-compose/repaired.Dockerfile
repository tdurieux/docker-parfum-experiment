FROM python:3.7-alpine

# Install dependencies
RUN pip install --no-cache-dir six
RUN pip install --no-cache-dir chardet
RUN pip install --no-cache-dir pdfkit
RUN apk add --no-cache --update wkhtmltopdf

# Copy source files and set entry point
COPY *.py /opt/bin/
ENTRYPOINT ["python", "/opt/bin/imapbox.py"]