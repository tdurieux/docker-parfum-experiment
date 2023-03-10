FROM python:3.7

# We add it to this path so that the relative paths to the `python_common` module match up
ADD ./scripts/combined_csv_writer /app/scripts/combined_csv_writer
ADD ./python_common /app/python_common

WORKDIR /app/python_common
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/scripts/combined_csv_writer
RUN pip install --no-cache-dir -r requirements.txt

CMD ["./run_exporter.sh"]
