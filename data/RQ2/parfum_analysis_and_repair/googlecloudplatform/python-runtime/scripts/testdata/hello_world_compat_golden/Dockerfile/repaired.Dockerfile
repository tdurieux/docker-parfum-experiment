FROM gcr.io/google_appengine/python-compat-multicore
ADD . /app/
RUN if [ -s requirements.txt ]; then \
 pip install --no-cache-dir -r requirements.txt; fi
