# parent image
FROM sqla:base

WORKDIR /sqla_exasol
ADD . /sqla_exasol

RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install -r requirements_test.txt
RUN pip install -r requirements_extras.txt

ENV ODBCSYSINI /sqla_exasol/odbcconfig

CMD ["/bin/bash"]
