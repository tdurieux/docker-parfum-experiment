FROM python:2.7

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y libqt4-dev cmake xvfb && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir numpy==1.13 pyside==1.2.4

COPY . /sharppy
WORKDIR /sharppy
RUN python setup.py install

WORKDIR /sharppy/runsharp
CMD python full_gui.py
