RUN pip install --no-cache-dir -e git+https://github.com/twintproject/twint.git@origin/master#egg=twint
RUN cd /mtriage/src/twint && python setup.py install
