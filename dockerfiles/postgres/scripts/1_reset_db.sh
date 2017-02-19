#!/bin/bash

sudo -u postgres psql <<END

DROP DATABASE IF EXISTS $SQLDBNAME;
CREATE DATABASE $SQLDBNAME;
CREATE USER $SQLUSER;
ALTER USER $SQLUSER PASSWORD '$SQLPASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $SQLDBNAME TO $SQLUSER;

\c $SQLDBNAME;

CREATE TABLE null_data (id SERIAL PRIMARY KEY,
                        tx_id bytea NOT NULL,
                        data bytea NOT NULL,
                        block_height integer NOT NULL);
ALTER TABLE null_data OWNER TO $SQLUSER;

CREATE UNIQUE INDEX unique_tx_id_block_time ON null_data (tx_id, block_time);
CREATE INDEX tx_id_seq ON null_data (tx_id);
CREATE INDEX data_seq ON null_data (data);

CREATE TABLE pallet(
               id SERIAL PRIMARY KEY,
               null_data_id INTEGER REFERENCES null_data(id) NOT NULL,
               header_ipfs_multihash VARCHAR(47) NOT NULL,
               ipfs_multihash VARCHAR(47),
               verified BOOLEAN);

ALTER TABLE pallet OWNER to $SQLUSER;

END