FROM python:3.8

# python installs
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

# set command
CMD ["bash"]
