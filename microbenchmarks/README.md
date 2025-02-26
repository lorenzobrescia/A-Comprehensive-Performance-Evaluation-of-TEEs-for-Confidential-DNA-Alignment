# Microbenchmarks

We provided a portable way for install and launch [Phoronix Test Suite](https://openbenchmarking.org/suites) microbenchmarks.

In the `install_benchmarks.sh` file there are all the test that you want to run.

In the `run_benchmarks.sh` file the test are executed one after the other.

The `user-config.xml` file it is necessary to performs all the microbenchmarks in batch.

Finally the `Dockerfile` will create the Docker image with all the tests installed. Then it is just necessary to build the image, run the container and attach to it to finally running the benchmarks:
```bash
docker build -t micro:performance . 
docker run -itd --name micro micro:performance
docker attach micro
nohup ./run_benchmarks.sh
```

Retrieve all `.log` results, before to stop and remove the container. This files can be further processed to obtain JSON structured files, by using the `clean_log_files.py`.