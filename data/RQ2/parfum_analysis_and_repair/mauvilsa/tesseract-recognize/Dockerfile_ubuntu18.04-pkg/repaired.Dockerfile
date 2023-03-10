FROM mauvilsa/pagexml:build-ubuntu18.04-py36

RUN apt-get update --fix-missing \
 && apt-get install -y --no-install-recommends \
      make \
      cmake \
      libtesseract-dev \
      libleptonica-dev \
      libgs-dev && rm -rf /var/lib/apt/lists/*;

COPY . /tmp/tesseract-recognize/

RUN cd /tmp/tesseract-recognize \
 && cmake -DCMAKE_BUILD_TYPE=Release . \
 && make


FROM mauvilsa/pagexml:runtime-ubuntu18.04-py36

MAINTAINER Mauricio Villegas <mauricio_ville@yahoo.com>

RUN apt-get update --fix-missing \
 && apt-get install -y --no-install-recommends \
      tesseract-ocr \
      ghostscript \
 && apt-get autoremove -y \
 && apt-get purge -y $(dpkg -l | awk '{if($1=="rc")print $2}') \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=0 /tmp/tesseract-recognize/tesseract-recognize /usr/local/bin/
COPY tesseract_recognize_api.py /usr/local/bin/
RUN sed -n '/^@requirements /{ s|^@requirements ||; p; }' /usr/local/bin/tesseract_recognize_api.py > /tmp/requirements.txt \
 && pip3 install --no-cache-dir -r /tmp/requirements.txt \
 && rm /tmp/requirements.txt

RUN useradd -m -u 1048 -g 0 tesseract
USER 1048
EXPOSE 5000
ENTRYPOINT /usr/local/bin/tesseract_recognize_api.py --host 0.0.0.0
