# Define connections
export DBEE_CONNECTIONS='[
    {
        "name": "{{ env "PGDATABASE" }}",
        "url": "postgres://{{ env "PGUSER" }}:{{ env "PGPASSWORD" }}@localhost:5432/{{ env "PGDATABASE" }}?sslmode=disable",
        "type": "postgres"
    },
    {
        "name": "{{ env "MYSQL_DATABASE" }}",
        "url": "mysql://{{ env "MYSQL_USER" }}:{{ env "MYSQL_PASSWORD" }}@localhost:3306/{{ env "MYSQL_DATABASE" }}",
        "type": "mysql"
    }
]'

# Export Postgres secrets
export PGUSER="postgres"
export PGPASSWORD="postgres"
export PGDATABASE="test"

# Export MariaDB secrets
export MYSQL_USER="root"
export MYSQL_PASSWORD="mariadb"
export MYSQL_DATABASE="test"
