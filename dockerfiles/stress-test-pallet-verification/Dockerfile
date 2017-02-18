FROM exo1/dev-base-haskell:latest

# Add stuff after this so we have a common image

WORKDIR /src/

RUN git clone https://gitlab.com/exo-one/stress-test-pallet-verification.git
RUN cd stress-test-pallet-verification/src && make && ./test
RUN stress-test-pallet-verification/src/perf
