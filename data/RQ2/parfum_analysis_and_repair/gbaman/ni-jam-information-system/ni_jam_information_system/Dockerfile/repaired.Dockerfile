FROM python:latest
EXPOSE 8000

# Install needed libraries
RUN mkdir /app
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt
RUN pip3 install --no-cache-dir gunicorn

# Copy app code over
COPY . /app
WORKDIR /app

# Run Gunicorn with the log file
CMD ["/usr/local/bin/gunicorn", "-w", "2", "-b", ":8000", "--log-file", "/var/nijis_logs/nijis.log", "--capture-output", "main:app"]