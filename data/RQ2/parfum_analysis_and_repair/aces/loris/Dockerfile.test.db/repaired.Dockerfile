FROM mysql:5.7

ARG BASE_DIR

COPY SQL/0000-00-00-schema.sql /0000-00-00-schema.sql
COPY SQL/0000-00-01-Modules.sql /0000-00-01-Modules.sql
COPY SQL/0000-00-02-Permission.sql /0000-00-02-Permission.sql
COPY SQL/0000-00-03-ConfigTables.sql /0000-00-03-ConfigTables.sql
COPY SQL/0000-00-04-Help.sql /0000-00-04-Help.sql
COPY SQL/0000-00-05-ElectrophysiologyTables.sql /0000-00-05-ElectrophysiologyTables.sql
COPY raisinbread/instruments/instrument_sql/aosi.sql  /aosi.sql
COPY raisinbread/instruments/instrument_sql/bmi.sql  /bmi.sql
COPY raisinbread/instruments/instrument_sql/medical_history.sql  /medical_history.sql
COPY raisinbread/instruments/instrument_sql/mri_parameter_form.sql  /mri_parameter_form.sql
COPY raisinbread/instruments/instrument_sql/radiology_review.sql  /radiology_review.sql
COPY test/test_instrument/testtest.sql /test_instrument.sql
COPY raisinbread/RB_files/*.sql /RB_files/

RUN echo "Use LorisTest;" | cat - \
    0000-00-00-schema.sql \
    0000-00-01-Modules.sql \
    0000-00-02-Permission.sql \
    0000-00-03-ConfigTables.sql \
    0000-00-04-Help.sql \
    0000-00-05-ElectrophysiologyTables.sql \
    aosi.sql \
    bmi.sql \
    medical_history.sql \
    mri_parameter_form.sql \
    radiology_review.sql \
    test_instrument.sql \
    RB_files/*.sql > /docker-entrypoint-initdb.d/0000-compiled.sql

RUN echo "Use LorisTest;" >> /docker-entrypoint-initdb.d/0001-paths.sql
RUN echo "UPDATE Config SET Value='${BASE_DIR}/' WHERE ConfigID=(SELECT ID FROM ConfigSettings WHERE Name='base');" >> /docker-entrypoint-initdb.d/0001-paths.sql
RUN echo "GRANT UPDATE,INSERT,SELECT,DELETE,DROP,CREATE TEMPORARY TABLES ON LorisTest.* TO 'SQLTestUser'@'%' IDENTIFIED BY 'TestPassword' WITH GRANT OPTION;" >> /docker-entrypoint-initdb.d/0004-sql-user.sql