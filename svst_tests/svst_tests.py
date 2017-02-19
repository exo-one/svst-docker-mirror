import logging

import datetime

logging.basicConfig(level=logging.INFO)

import time
import json
import socket
import sys, os

import psycopg2

import bitcoin
from bitcoinrpc.authproxy import AuthServiceProxy, EncodeDecimal, JSONRPCException


def fancy_log(title, thing):
    to_print = thing
    if type(thing) is dict:
        to_print = json.dumps(thing, indent=2, default=EncodeDecimal)
    elif type(thing) is not str:
        to_print = repr(thing)

    print()
    print("########" * 2 + "#" * len(title))
    print("####### %s #######" % title)
    print("########" * 2 + "#" * len(title))
    print()
    print(to_print)
    print()


while True:  # continuously attempt to do this until they are up
    try:
        try:
            bitcoind = AuthServiceProxy("http://%s:%s@bitcoind:8332" % (os.getenv('RPCUSER'), os.getenv('RPCPASSWORD')))
            bitcoind.getinfo()  # try to connect in some way
        except socket.gaierror:
            bitcoind = AuthServiceProxy("http://%s:%s@127.0.0.1:8332" % (os.getenv('RPCUSER'), os.getenv('RPCPASSWORD')))
            bitcoind.getinfo()
    except (socket.gaierror, JSONRPCException) as e:
        logging.info("Sleeping 5; Unable to connect to Bitcoind or IPFS: %s" % e)
        time.sleep(5)
    else:
        break


dbname = os.getenv('SQLDBNAME')
sqlconn = psycopg2.connect(database=dbname, host=os.getenv('SQLHOST'),
                           user=os.getenv('SQLUSER'), password=os.getenv('SQLPASSWORD'))


def run_query(sql_query):
    cur = sqlconn.cursor()
    cur.execute(sql_query)
    return cur.fetchall()


def do_test_round():
    fancy_log("Round Start", {'time': time.time(), 'date': repr(datetime.datetime.now())})
    # first confirm everything and generate coins
    bitcoind.generate(128)
    fancy_log("Bitcoin Getinfo", bitcoind.getinfo())

    # wait for scraper to register some things



ROUND_TIME_SEC = 3
for round_n in range(100):
    r_start = time.time()
    do_test_round()
    time.sleep(max(ROUND_TIME_SEC - time.time() + r_start, 0))

