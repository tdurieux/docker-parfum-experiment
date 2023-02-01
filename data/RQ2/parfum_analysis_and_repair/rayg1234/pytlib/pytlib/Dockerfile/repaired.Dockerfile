# this is currently broken, untested
FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ADD Pipfile /
RUN pip3 install --no-cache-dir Cython
RUN pipenv install
RUN echo 'export PYTHONPATH="${PYTHONPATH}:/pytlib"' >> ~/.bashrc

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

