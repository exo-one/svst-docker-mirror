#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL

-- All nulldata stored here
CREATE TABLE null_data
    ( id SERIAL PRIMARY KEY
    , prefix bytea NOT NULL
    , tx_id bytea NOT NULL
    , data bytea NOT NULL
    , block_time integer NOT NULL
    , block_hash bytea NOT NULL
    );

CREATE UNIQUE INDEX unique_tx_id_block_hash ON null_data (tx_id, block_hash);
CREATE INDEX tx_id_seq ON null_data (tx_id);
CREATE INDEX data_seq ON null_data (data);
CREATE INDEX prefix_seq ON null_data (prefix);

-- LEGACY TABLE, added in to avoid doing more work
CREATE TABLE pallet
    ( id SERIAL PRIMARY KEY
    , null_data_id INTEGER REFERENCES null_data(id) NOT NULL
    , header_ipfs_multihash VARCHAR(47) NOT NULL
    , ipfs_multihash VARCHAR(47)
    , pallet_dl BOOLEAN DEFAULT false
    , header_dl BOOLEAN DEFAULT false
    , verified BOOLEAN DEFAULT false
    );

-- Track block data
CREATE TABLE block_data
    ( id SERIAL PRIMARY KEY
    , block_hash bytea NOT NULL
    , previous_block_hash bytea NOT NULL
    , block_height integer NOT NULL
    , block_time integer NOT NULL
    );

-- If it has been processed, it will appear in this table, otherwise we can
-- assume it hasn't been processed
CREATE TABLE nd_processed
    ( id SERIAL PRIMARY KEY
    , nd_id integer NOT NULL
    );

-- All headers we know about are stored here
CREATE TABLE header_data
    ( id SERIAL PRIMARY KEY
    , header_multihash varchar(50) NOT NULL
    , last_processed integer NOT NULL
    );

-- Headers we process are here
CREATE TABLE header_processed
    ( _id SERIAL PRIMARY KEY
    , header_multihash varchar(50) NOT NULL
    , valid BOOLEAN DEFAULT false
    , pallet_multihash varchar(50) NOT NULL
    );

-- All pallets we know about go here
CREATE TABLE pallet_index
    ( id SERIAL PRIMARY KEY
    , pallet_multihash varchar(50) NOT NULL
    , last_processed integer NOT NULL
    );

-- Data about pallets we've downloaded
CREATE TABLE pallet_downloaded
    ( id SERIAL PRIMARY KEY
    , pallet_multihash varchar(50) NOT NULL
    );

-- Data about pallets we've validated
CREATE TABLE pallet_validated
    ( id SERIAL PRIMARY KEY
    , pallet_multihash varchar(50) NOT NULL
    , valid BOOLEAN DEFAULT false
    , n_votes integer NOT NULL
    , votes_for integer NOT NULL
    , votes_against integer NOT NULL
    );

-- Cache of state (one row only)
CREATE TABLE state_cache
    ( id SERIAL PRIMARY KEY
    , last_processed integer NOT NULL
    , total_pallets integer NOT NULL
    , total_boxes integer NOT NULL
    , total_votes integer NOT NULL
    , total_votes_for integer NOT NULL
    , total_votes_against integer NOT NULL
    );

EOSQL
