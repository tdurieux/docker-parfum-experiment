FROM postgres:11
COPY sql/create_table.sql /docker-entrypoint-initdb.d/01_create_table.sql
COPY sql/import_quotes.sql /docker-entrypoint-initdb.d/02_import_quotes.sql
COPY sql/quotes_data.txt /quotes_data.txt