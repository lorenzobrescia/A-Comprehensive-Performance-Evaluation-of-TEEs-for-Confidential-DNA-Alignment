FROM ubuntu:noble

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip wget g++ make libz-dev bowtie2

# Move to the /root directory
WORKDIR /root

# Move to the /root directory
WORKDIR /root
# Copy your Bowtie2 input files
COPY bowtie_input_files/ /bowtie_input_files/
COPY perf.sh .
RUN chmod +x perf.sh