# Mock arXiv.org

FROM arxiv/base:0.15.6

WORKDIR /opt/arxiv

# MySQL is needed for the arxiv-auth package.
RUN yum install -y which mysql mysql-devel && rm -rf /var/cache/yum

# Add Python consumer and configuration.
RUN pip install --no-cache-dir -U pip pipenv uwsgi
RUN pipenv install flask uwsgi

ADD extractor/tests/pdfs/1702.07336.pdf /opt/arxiv/
ADD mock_arxiv.py /opt/arxiv/

ENTRYPOINT ["pipenv", "run"]
CMD ["uwsgi", "--http-socket", ":8000", "-M", "-t", "3000", "--manage-script-name", "--processes", "8", "--threads", "1", "--mount", "/=mock_arxiv.py"]
