#!/bin/bash
if [ "$API_DATABASE_URL" != "" ]; then
    echo "Found database configuration in API_DATABASE_URL=$API_DATABASE_URL"

    regex='^(postgres|mysql)://([a-zA-Z0-9_-]+):(.*)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)\?(.*)$'
    if [[ $API_DATABASE_URL =~ $regex ]]; then
        export DB_VENDOR=${BASH_REMATCH[1]}
        export DB_USER=${BASH_REMATCH[2]}
        export DB_PASSWORD=${BASH_REMATCH[3]}
        export DB_ADDR=${BASH_REMATCH[4]}
        export DB_PORT=${BASH_REMATCH[5]}
        export DB_DATABASE=${BASH_REMATCH[6]}
        export JDBC_PARAMS=${BASH_REMATCH[7]}

        if [ "$DB_VENDOR" == "postgres" ]; then
            export DB_TYPE="postgre"
            export DB_DRIVER="org.postgresql.Driver"
            export DB_VALIDATION_QUERY="SELECT 1"
            export DB_URL="jdbc:postgresql://$DB_ADDR:$DB_PORT/$DB_DATABASE"
        else
            export DB_TYPE="mysql"
            export DB_DRIVER="com.mysql.cj.jdbc.Driver"
            export DB_VALIDATION_QUERY="SELECT 1"
            export DB_URL="jdbc:mysql://$DB_ADDR:$DB_PORT/$DB_DATABASE"
        fi

        echo "DB_ADDR=$DB_ADDR, DB_PORT=$DB_PORT, DB_DATABASE=$DB_DATABASE, DB_USER=$DB_USER, DB_PASSWORD=$DB_PASSWORD, JDBC_PARAMS=$JDBC_PARAMS"
    fi
fi

if [ "$SHARED_DATABASE_URL" != "" ]; then
    echo "Found database configuration in SHARED_DATABASE_URL=$SHARED_DATABASE_URL"

    regex='^(postgres|mysql)://([a-zA-Z0-9_-]+):(.*)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)\?(.*)$'
    if [[ $SHARED_DATABASE_URL =~ $regex ]]; then
        export S_DB_VENDOR=${BASH_REMATCH[1]}
        export S_DB_USER=${BASH_REMATCH[2]}
        export S_DB_PASSWORD=${BASH_REMATCH[3]}
        export S_DB_ADDR=${BASH_REMATCH[4]}
        export S_DB_PORT=${BASH_REMATCH[5]}
        export S_DB_DATABASE=${BASH_REMATCH[6]}
        export S_JDBC_PARAMS=${BASH_REMATCH[7]}

        if [ "$S_DB_VENDOR" == "postgres" ]; then
            export S_DB_TYPE="postgre"
            export S_DB_DRIVER="org.postgresql.Driver"
            export S_DB_VALIDATION_QUERY="SELECT 1"
            export S_DB_URL="jdbc:postgresql://$S_DB_ADDR:$S_DB_PORT/$S_DB_DATABASE"
        else
            export S_DB_TYPE="mysql"
            export S_DB_DRIVER="com.mysql.cj.jdbc.Driver"
            export S_DB_VALIDATION_QUERY="SELECT 1"
            export S_DB_URL="jdbc:mysql://$S_DB_ADDR:$S_DB_PORT/$S_DB_DATABASE"
        fi

        echo "DB_ADDR=$S_DB_ADDR, DB_PORT=$S_DB_PORT, DB_DATABASE=$S_DB_DATABASE, DB_USER=$S_DB_USER, DB_PASSWORD=$S_DB_PASSWORD DB_VENDOR=$S_DB_VENDOR;DB_URL=$S_DB_URL;DB_TYPE=$S_DB_TYPE;DB_VALIDATION_QUERY=$S_DB_VALIDATION_QUERY; "
    fi

fi


set -e
/home/wso2carbon/docker-entrypoint.sh

