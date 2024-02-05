# Define connections
export DBEE_CONNECTIONS='[
    {
        "name": "{{ exec `echo Hidden Database` }}",
        "url": "postgres://{{ env \"PGUSER\" }}:{{ env `PGPASSWORD` }}@localhost:5432/{{ env `PGDATABASE` }}?sslmode=disable",
        "type": "postgres"
    }
]'

# Export secrets
export PGUSER="postgres"
export PGPASSWORD="mysecretpassword"
export PGDATABASE="mydb"
