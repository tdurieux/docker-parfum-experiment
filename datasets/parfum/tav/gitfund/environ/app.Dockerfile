# Public Domain (-) 2016 The GitFund Authors.
# See the GitFund UNLICENSE file for details.

# Python Dependencies
RUN pip install --target /service/pypkg pygments==2.1.3 && \
    python -m compileall /service/pypkg
