FROM python:3.9-buster

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost:5000/ping || exit 1

VOLUME ["/storage", "/configuration"]

WORKDIR /app

# libgphoto2
RUN curl -f -o gphoto2-updater.sh -L "https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh" \
    && curl -f -o .env -L "https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/.env" \
    && chmod +x gphoto2-updater.sh \
    && ./gphoto2-updater.sh -s

# Coral Edge TPU
# RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list \
#     && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
#     && apt-get update \
#     && apt-get install libedgetpu1-std -y

# ExifTool
RUN apt-get install --no-install-recommends libimage-exiftool-perl -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Python code
COPY . ./
RUN python -m compileall .

# Uncomment this if you have a Google Coral Edge TPU
# CMD ["python", "webapp.py", "-tpu", "--destination", "/storage/share", "--archive", "/storage/archive", "--temp", "/storage/tmp"]
CMD ["python", "webapp.py", "--destination", "/storage/share", "--archive", "/storage/archive", "--temp", "/storage/tmp"]