FROM ubuntu:noble

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip wget g++ make libz-dev minimap2

# Move to the /root directory
WORKDIR /root

# Move to the /root directory
WORKDIR /root
# Copy your Bowtie2 input files
COPY minimap_input_files/ /minimap_input_files/
COPY perf.sh .
RUN chmod +x perf.sh