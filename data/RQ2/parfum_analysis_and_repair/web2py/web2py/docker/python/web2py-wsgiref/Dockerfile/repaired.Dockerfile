FROM python:2.7

#LABEL your_label

RUN apt update && \
 apt install --no-install-recommends -y unzip wget python-pip && \
 pip install --no-cache-dir --upgrade pip && \
 pip install --no-cache-dir wsgiref && rm -rf /var/lib/apt/lists/*;

RUN groupadd -r web2py && \
 useradd -m -r -g web2py web2py

USER web2py

RUN cd /home/web2py/ && \
 wget -c https://web2py.com/examples/static/web2py_src.zip && \
 unzip -o web2py_src.zip && \
 rm -rf /home/web2py/web2py/applications/examples && \
 chmod 755 -R /home/web2py/web2py

WORKDIR /home/web2py/web2py

EXPOSE 8000

CMD python /home/web2py/web2py/anyserver.py -s wsgiref -i 0.0.0.0 -p 8000
