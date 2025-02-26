#!/bin/bash
RESULT_FOLDER="results"
mkdir -p "$RESULT_FOLDER"

# Function to run a benchmark with a specific name
run_benchmark() {
    test_name=$1
    result_name=$2

    echo "Running benchmark: $test_name"
    phoronix-test-suite batch-benchmark "$test_name" > "${RESULT_FOLDER}/${result_name}.log" 2>&1
    echo "Saved result: ${RESULT_FOLDER}/${result_name}.log"
}

# Ensure Phoronix Test Suite is installed
if ! command -v phoronix-test-suite &> /dev/null; then
    echo "Phoronix Test Suite is not installed. Please install it and try again."
    exit 1
fi

run_benchmark "pts/stress-ng" "stress_ng_results"
run_benchmark "pts/sysbench" "sysbench_results"
run_benchmark "pts/mutex" "mutex_results"
run_benchmark "pts/hackbench" "hackbench_results"
run_benchmark "pts/ipc-benchmark" "ipc_benchmark_results"
run_benchmark "pts/osbench" "osbench_results"
run_benchmark "pts/ramspeed" "ramspeed_results"
run_benchmark "pts/stream" "stream_results"
run_benchmark "pts/cachebench" "cachebench_results"