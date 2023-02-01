FROM gcr.io/google_appengine/python
LABEL python_version={{python_version}}
RUN virtualenv --no-download /env -p {{python_version}}
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH
ADD requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /app/
CMD {{entrypoint}}
