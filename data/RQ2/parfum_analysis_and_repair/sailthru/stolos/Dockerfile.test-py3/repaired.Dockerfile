FROM python:3

WORKDIR /stolos/
ADD ./setup.py /stolos/setup.py
ADD ./bin/stolos-submit /stolos/bin/stolos-submit
RUN cd /stolos/ && pip install --no-cache-dir .[testing,redis] && python setup.py develop
# assumes code base mounted as volume
CMD /stolos/bin/test_stolos
