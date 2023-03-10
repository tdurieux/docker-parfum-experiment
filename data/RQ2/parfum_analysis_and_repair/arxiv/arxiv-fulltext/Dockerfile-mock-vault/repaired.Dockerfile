# Mock arXiv.org

FROM arxiv/base:0.15.6

WORKDIR /opt/arxiv

# MySQL is needed for the arxiv-auth package.
RUN yum install -y which mysql mysql-devel && rm -rf /var/cache/yum

# Add Python consumer and configuration.
RUN pip install --no-cache-dir -U pip pipenv uwsgi
RUN pipenv install flask uwsgi

ADD mock_vault.py /opt/arxiv/

EXPOSE 8200

ENTRYPOINT ["pipenv", "run"]
CMD ["uwsgi", "--http-socket", ":8200", "-M", "-t", "3000", "--manage-script-name", "--processes", "1", "--threads", "1", "--mount", "/=mock_vault.py"]
