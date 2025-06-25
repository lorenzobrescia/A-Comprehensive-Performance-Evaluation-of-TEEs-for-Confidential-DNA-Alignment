FROM gramineproject/gramine:1.7-focal

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip wget g++ make git libz-dev

# Move to the /root directory
WORKDIR /root
RUN git clone https://github.com/lh3/minimap2.git && \
    cd minimap2 && \
    git checkout v2.26 && \
    make && \
    cp minimap2 /usr/bin/ && \
    cd .. && \
    rm -rf minimap2

# Move to the /root directory
WORKDIR /root

# Create the necessary directories for small workload
RUN mkdir -p /root/small/results
# Copy files from host
COPY Makefile /root/small/Makefile
COPY manifest_small /root/small/manifest.template

# Create the necessary directories for big workload
RUN mkdir -p /root/big/results
# Copy files from host
COPY Makefile /root/big/Makefile
COPY manifest_big /root/big/manifest.template

# Copy commons files from host
COPY minimap_input_files/index /minimap_input_files/index
COPY minimap_input_files/reads /minimap_input_files/reads

# Benchmark script
COPY perf.sh .
RUN chmod +x perf.sh

# Create the key for Gramine tools
RUN gramine-sgx-gen-private-key