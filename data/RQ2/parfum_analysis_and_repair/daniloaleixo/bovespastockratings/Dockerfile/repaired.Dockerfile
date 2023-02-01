FROM python


COPY fundamentus.py /data/fundamentus.py
COPY waitingbar.py /data/waitingbar.py
WORKDIR /data

# RUN pip install -r requirements.txt
RUN pip install --no-cache-dir --upgrade lxml && \
    pip install --no-cache-dir --upgrade python_jwt && \
    pip install --no-cache-dir --upgrade gcloud && \
    pip install --no-cache-dir --upgrade sseclient && \
    pip install --no-cache-dir --upgrade Crypto && \
    pip install --no-cache-dir --upgrade pycryptodome==3.4.3 && \
    pip install --no-cache-dir --upgrade requests_toolbelt && \
    pip install --no-cache-dir --upgrade pymongo && \
    pip install --no-cache-dir sendgrid && \
    python -m pip install pymongo[srv]

CMD python3 fundamentus.py