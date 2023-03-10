FROM library/python:3.6
RUN pip install --no-cache-dir pytest
# by default, target source code will be at /floop/
# on the target device run environment
# use the python -B flag to suppress __pycache__
# use the pytest -p flag to suppress .pytest_cache
CMD python -B -m pytest -p no:cacheprovider -v -s /floop
