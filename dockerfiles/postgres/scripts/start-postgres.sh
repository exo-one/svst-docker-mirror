#!/bin/bash

if [[ $RESETDB ]]; then
    echo "Resetting DB"
    echo "******************************************************************"
    echo "*** This will destroy 'svst_nulldata' database and recreate it ***"
    echo "******************************************************************"
    ./1_reset_db.sh
else
    echo "Not resetting db..."
fi

postgres