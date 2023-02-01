FROM python:3.7-slim-buster

# expose port
EXPOSE 8000

# install chromedriver
RUN apt-get update && apt-get install --no-install-recommends -y \
    chromium-driver && rm -rf /var/lib/apt/lists/*;

# upgrade pip and install requirements.txt
ADD requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# add the script to where selenium is installed
ADD main.py /usr/local/lib/python3.7/site-packages

RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# run the script
CMD [ "python3.7", "/usr/local/lib/python3.7/site-packages/main.py"]
