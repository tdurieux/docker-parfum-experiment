FROM python:3

# Installing 4scanner
RUN pip install --no-cache-dir 4scanner
RUN mkdir /output

# Volume for config json file + output
VOLUME ["/output"]

CMD ["4scanner", "-o", "/output", "/output/config.json"]
