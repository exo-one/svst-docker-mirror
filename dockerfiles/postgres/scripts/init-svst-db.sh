#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL

    CREATE TABLE null_data (id SERIAL PRIMARY KEY,
                            prefix bytea NOT NULL,
                            tx_id bytea NOT NULL,
                            data bytea NOT NULL,
                            block_time integer NOT NULL,
                            block_height integer NOT NULL,
                            block_hash bytea NOT NULL);

    CREATE UNIQUE INDEX unique_tx_id_block_time ON null_data (tx_id, block_time);
    CREATE INDEX tx_id_seq ON null_data (tx_id);
    CREATE INDEX data_seq ON null_data (data);
    CREATE INDEX prefix_seq ON null_data (prefix);

    CREATE TABLE pallet(
                   id SERIAL PRIMARY KEY,
                   null_data_id INTEGER REFERENCES null_data(id) NOT NULL,
                   header_ipfs_multihash VARCHAR(47) NOT NULL,
                   ipfs_multihash VARCHAR(47),
                   pallet_dl BOOLEAN DEFAULT false,
                   header_dl BOOLEAN DEFAULT false,
                   verified BOOLEAN DEFAULT false);

EOSQL