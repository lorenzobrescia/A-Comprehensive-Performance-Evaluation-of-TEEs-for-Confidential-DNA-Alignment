FROM ubuntu:focal

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip wget g++ make git libz-dev

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

# Move to the /root directory
WORKDIR /root
# Copy your Bowtie2 input files
COPY minimap_input_files/ /minimap_input_files/
COPY perf.sh .
RUN chmod +x perf.sh