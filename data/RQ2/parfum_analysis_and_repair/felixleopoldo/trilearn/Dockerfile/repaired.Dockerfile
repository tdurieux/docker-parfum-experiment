FROM onceltuca/pygraphviz

RUN pip install --no-cache-dir pyrsistent==0.16.0
RUN pip install --no-cache-dir tabulate
RUN pip install --no-cache-dir trilearn==1.23
