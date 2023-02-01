FROM bc21-env

# Install software dependencies
RUN pip3 install --no-cache-dir --upgrade \
    apscheduler \
    requests

COPY config.py util.py scrimmage.py app/
CMD python3 /app/scrimmage.py
