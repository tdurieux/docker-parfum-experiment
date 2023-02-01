FROM sphinxdoc/sphinx

RUN apt-get update \
 && apt install --no-install-recommends -y doxygen graphviz \
 && apt-get autoremove \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install breathe pydot

WORKDIR /
