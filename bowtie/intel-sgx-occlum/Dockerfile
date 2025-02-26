FROM occlum/occlum:0.30.0-ubuntu20.04

# Install necessary tools to compile Bowtie2 from source
RUN apt-get update && apt-get install -y unzip g++ bowtie2

# Move to the /root directory
WORKDIR /root

# Copy a directory from host to container directory
COPY bowtie_input_files/index /bowtie_input_files/index
COPY bowtie_input_files/reads /bowtie_input_files/reads

# Create the necessary directories for no-edmm
RUN mkdir -p /root/demos/bowtie2/no-edmm/results
RUN mkdir -p /root/demos/bowtie2/no-edmm/ws
COPY bow.yaml /root/demos/bowtie2/no-edmm/bow.yaml

# Setup occlum workspace for no-edmm
WORKDIR /root/demos/bowtie2/no-edmm/ws
RUN occlum init && rm -rf image
RUN copy_bom -f ../bow.yaml --root image --include-dir /opt/occlum/etc/template
COPY no_edmm.json /root/demos/bowtie2/no-edmm/ws/Occlum.json
RUN occlum build

# Create the necessary directories for edmm
RUN mkdir -p /root/demos/bowtie2/edmm/results
RUN mkdir -p /root/demos/bowtie2/edmm/ws
COPY bow.yaml /root/demos/bowtie2/edmm/bow.yaml

# Setup occlum workspace for edmm
WORKDIR /root/demos/bowtie2/edmm/ws
RUN occlum init && rm -rf image
RUN copy_bom -f ../bow.yaml --root image --include-dir /opt/occlum/etc/template
COPY edmm.json /root/demos/bowtie2/edmm/ws/Occlum.json
RUN ENABLE_EDMM=Y occlum build

WORKDIR /root/demos/bowtie2
COPY perf.sh .
RUN chmod +x perf.sh

# Example of run with 16 threads and EDMM enabled
# RUN ENABLE_EDMM=Y occlum build
# RUN occlum run /bin/bowtie2-align-s -x "/bowtie_input_files/index/hg38" -p "32" -1 "/bowtie_input_files/reads/SRR31527206/1.fastq" -2 "/bowtie_input_files/reads/SRR31527206/2.fastq" -S "/host/sample.sam"
