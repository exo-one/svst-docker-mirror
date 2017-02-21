import logging

import datetime

logging.basicConfig(level=logging.INFO, format='%(message)s')

import time
import json
import socket
import sys, os
from pprint import pformat

import psycopg2

import bitcoin
import bitcoin.base58
from bitcoinrpc.authproxy import AuthServiceProxy, EncodeDecimal, JSONRPCException


def fancy_log(title, thing):
    logging.info("")
    logging.info("########" * 2 + "#" * len(title))
    logging.info("####### %s #######" % title)
    logging.info("########" * 2 + "#" * len(title))
    logging.info("")
    logging.info(pformat(thing, indent=2))
    logging.info("")


magic_bytes = os.getenv('MAGICBYTES')
dbname = os.getenv('POSTGRES_DB')
dbhost = os.getenv('POSTGRES_HOST')
NUM_PALLETS = int(os.getenv('NUM_PALLETS', 20))
rpcuser = os.getenv('RPCUSER')
rpcpassword = os.getenv('RPCPASSWORD')
fancy_log("Environment Variables", {k: os.getenv(k) for k in os.environ.keys()})


while True:  # continuously attempt to do this until they are up
    try:
        try:
            bitcoind = AuthServiceProxy("http://%s:%s@bitcoind:8332" % (rpcuser, rpcpassword))
            bitcoind.getinfo()  # try to connect in some way
        except socket.gaierror:  # Just DNS!
            logging.info("Trying localhost...")
            bitcoind = AuthServiceProxy("http://%s:%s@127.0.0.1:8332" % (rpcuser, rpcpassword))
            bitcoind.getinfo()

        dbhost_ip = socket.gethostbyname(dbhost)
        sqlconn = psycopg2.connect(database=dbname, host=dbhost_ip,
                                   user=os.getenv('POSTGRES_USER'))

    except (socket.gaierror, JSONRPCException, psycopg2.OperationalError) as e:
        logging.info("Bitcoind auth: %s, %s" % (rpcuser, rpcpassword))
        logging.info("SVST Test Sleeping 5; Unable to connect to Bitcoind or Postgres: %s" % e)
        time.sleep(5)
    else:
        break


def run_query(sql_query, args=()):
    cur = sqlconn.cursor()
    try:
        cur.execute(sql_query, args)
        logging.info("Executed:\n%s" % (sql_query, ))
    except psycopg2.ProgrammingError as e:
        fancy_log("SQL Error", e)
        raise e
    if sql_query[:6] not in ["INSERT", "UPDATE"]:
        _rows = list(cur.fetchall())
        logging.info("Response has %d rows" % len(_rows))
        rows = [[a if type(a) is not memoryview else bytes(a) for a in row] for row in _rows]
    else:
        rows = []
    sqlconn.commit()
    return list(rows)



last_scrape_n = 0
last_header_n = 0
last_pallet_index_n = 0
def do_test_round():
    global last_scrape_n, last_header_n, last_pallet_index_n
    # first confirm everything and generate coins
    bitcoind.generate(128)
    getinfo = bitcoind.getinfo()
    fancy_log("Limited Bitcoin Getinfo", {'blocks': getinfo['blocks'], 'balance': getinfo['balance']})

    # wait for scraper to register some things
    all_scrapes = run_query("SELECT id, prefix, tx_id, data, block_time, block_hash FROM null_data")
    fancy_log("Last Scrape", [] if len(all_scrapes) == 0 else all_scrapes[-1])
    assert len(all_scrapes) >= last_scrape_n
    last_scrape_n = len(all_scrapes)
    for id, prefix, txid, nd, btime, bhash in all_scrapes:
        assert nd[:len(magic_bytes)] == magic_bytes.encode()
        assert len(nd) == 40

    # now check pallet header download
    all_headers_processed = run_query("SELECT * FROM header_processed")
    logging.info("Got %d headers in header_processed" % len(all_headers_processed))
    fancy_log("Last Header", [] if len(all_headers_processed) == 0 else all_headers_processed[-1])
    for id, header_multihash, valid, pallet_multihash in all_headers_processed:
        assert len(bitcoin.base58.decode(header_multihash)) == 34
        if valid:
            assert len(bitcoin.base58.decode(pallet_multihash)) == 34
        else:
            assert len(pallet_multihash) == 0
    last_header_n = len(run_query("SELECT * FROM header_processed WHERE valid = true"))
    logging.info("Got %d valid headers" % last_header_n)

    all_pallets_in_index = run_query("SELECT * FROM pallet_index")
    last_pallet_index_n = len(all_pallets_in_index)
    logging.info("Got %d pallets in index" % last_pallet_index_n)




ROUND_TIME_SEC = 1.0
NUM_ROUNDS = max(NUM_PALLETS * 3, 20)
for round_n in range(NUM_ROUNDS):
    r_start = time.time()
    fancy_log("Round %d / %d" % (round_n + 1, NUM_ROUNDS), {'time': time.time(), 'date': repr(datetime.datetime.now())})
    do_test_round()
    time.sleep(max(ROUND_TIME_SEC - time.time() + r_start, 0))

    if last_scrape_n == NUM_PALLETS and last_header_n == NUM_PALLETS and last_pallet_index_n == NUM_PALLETS:
        break

assert last_scrape_n == NUM_PALLETS
assert last_header_n == NUM_PALLETS

