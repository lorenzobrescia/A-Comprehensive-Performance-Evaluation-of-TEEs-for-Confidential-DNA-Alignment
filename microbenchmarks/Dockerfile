FROM ubuntu:noble

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip wget g++ make libz-dev git php-cli php-xml pkg-config libelf-dev python3-dev python3-pip

# Move to the /root directory and install phoronix-test-suite
WORKDIR /root
RUN git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git
WORKDIR /root/phoronix-test-suite/
RUN ./install-sh

WORKDIR /root
RUN rm -rf phoronix-test-suite/

# Copy necessary files
COPY install_benchmarks.sh install_benchmarks.sh
COPY run_benchmarks.sh run_benchmarks.sh
COPY user-config.xml /etc/phoronix-test-suite.xml 

# Copy necessary files
RUN chmod +x install_benchmarks.sh
RUN chmod +x run_benchmarks.sh

RUN ./install_benchmarks.sh