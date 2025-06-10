# Microbenchmarks

We provided a portable way for install and launch [Phoronix Test Suite](https://openbenchmarking.org/suites) microbenchmarks.

In the `install_benchmarks.sh` file there are all the test that you want to run.

In the `run_benchmarks.sh` file the test are executed one after the other.

In the `test_names.json` there are all the name tests in the phoronix test suite.

The `user-config.xml` file it is necessary to performs all the microbenchmarks in batch.

Finally the `Dockerfile` will create the Docker image with all the tests installed. Then it is just necessary to build the image, run the container and attach to it to finally running the benchmarks:
```bash
docker build -t micro:performance . 
docker run -itd --name micro micro:performance
docker attach micro
nohup ./run_benchmarks.sh
```

Retrieve all `.log` results, before to stop and remove the container.
```bash
docker cp micro:/root/results .
```

Now you have a folder `results` with all log files of the microbenchmark.
These files can be further processed to obtain JSON structured files, by using the `clean_log_files.py` script.
```bash 
python3 clean_log_files.py results
```

It will create `results/cleaned` folder with all escaped log files and a `results/cleaned/result.json` file with all the test structured in json like the following:
```json
[
  {
    "pts/hackbench-1.0.0": [
      {
        "description": "Count: 1 - Type: Thread",
        "values": [
          2.747,
          2.748,
          2.892,
          2.919,
          2.656,
          2.763,
          2.653,
          2.709,
          2.866,
          2.795,
          2.689,
          2.688,
          2.734,
          2.698,
          2.686
        ],
        "unit": "Seconds",
        "average": 2.749533333333334,
        "std_dev": 0.08121236906339382
      },
      {
        "description": "Count: 2 - Type: Thread",
        "values": [
          4.212,
          4.281,
          4.342
        ],
        "unit": "Seconds",
        "average": 4.278333333333332,
        "std_dev": 0.05310576449145815
      },
      // etc ...
    ]
  },
  {
    "pts/cachebench-1.2.0": [
      {
        "description": "Test: Read",
        "values": [
          9404.792157,
          9405.218233,
          9405.484625
        ],
        "unit": "MB/s",
        "average": 9405.165005,
        "std_dev": 0.28519338204541855
      },
      {
        "description": "Test: Write",
        "values": [
          56363.307323,
          56356.34726,
          56356.561183
        ],
        "unit": "MB/s",
        "average": 56358.73858866666,
        "std_dev": 3.23176327711044
      },
      {
        "description": "Test: Read / Modify / Write",
        "values": [
          107804.161002,
          107620.765901,
          107666.242871
        ],
        "unit": "MB/s",
        "average": 107697.05659133331,
        "std_dev": 77.9767263922798
      }
    ]
  },
  {
    "pts/ramspeed-1.4.3": [
      // etc ...
    ]
  }
]
```