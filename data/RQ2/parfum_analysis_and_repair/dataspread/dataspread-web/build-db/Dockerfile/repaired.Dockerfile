# Use postgres 10.14
FROM postgres:10.14

# Creates database with name "dataspread_db" and superuser with username "admin" and password "password"
# Any changes to these values should also be made to the "jdbc/ibd" Resource in context.xml