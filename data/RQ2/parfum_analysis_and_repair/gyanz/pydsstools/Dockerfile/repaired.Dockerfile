FROM osgeo/gdal

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install gfortran python3.8 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY . /

RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir --upgrade -r requirements.txt \
    && python setup.py install

# Entrypoint script
RUN chmod +x /script.sh
ENTRYPOINT [ "/script.sh" ]

# Argument(s) to enttrypoint script
CMD ["false", "test1.py", "test2.py", "test3.py"]
