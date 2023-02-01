FROM kartoza/osm-reporter

RUN pip install --no-cache-dir nose nosexcover
ENV PYTHONPATH=/reporter
CMD ["nosetests", "-v", "--with-id", "--with-xcoverage", "--with-xunit", "--verbose", "--cover-package=reporter", "reporter"]
