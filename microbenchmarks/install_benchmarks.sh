#!/bin/bash

# General (CPU and memory)
phoronix-test-suite install stress-ng
phoronix-test-suite install sysbench

# Kernel
phoronix-test-suite install mutex
phoronix-test-suite install hackbench
phoronix-test-suite install ipc-benchmark
phoronix-test-suite install osbench

# Memory
phoronix-test-suite install ramspeed
phoronix-test-suite install stream
phoronix-test-suite install cachebench