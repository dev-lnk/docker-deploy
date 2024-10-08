FROM mysql:8.0.33

ARG password

COPY ./docker/deployment/config/mysql/create_database.sql /docker-entrypoint-initdb.d/create_database.sql
RUN echo "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${password}';" >> /docker-entrypoint-initdb.d/set_native_password.sql
COPY ./docker/deployment/config/mysql/mysql.cnf /etc/mysql/conf.d/mysql.cnf
