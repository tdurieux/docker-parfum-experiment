FROM sphinxdoc/sphinx

WORKDIR /docs
ADD requirements.txt /docs
RUN pip3 install --no-cache-dir -r requirements.txt

CMD sphinx-autobuild -b html --host 0.0.0.0 --port 8800 /docs /docs/_build/html
