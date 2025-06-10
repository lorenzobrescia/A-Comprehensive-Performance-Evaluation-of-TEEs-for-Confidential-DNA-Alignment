FROM occlum/occlum:0.30.0-ubuntu20.04

# Install necessary tools to compile minimap2 from source
RUN apt-get update && apt-get install -y unzip g++ minimap2

# Move to the /root directory
WORKDIR /root

# Copy a directory from host to container directory
COPY minimap_input_files/index /minimap_input_files/index
COPY minimap_input_files/reads /minimap_input_files/reads

# Create the necessary directories for no-edmm
RUN mkdir -p /root/demos/minimap2/no-edmm/results
RUN mkdir -p /root/demos/minimap2/no-edmm/ws
COPY mini.yaml /root/demos/minimap2/no-edmm/mini.yaml

# Setup occlum workspace for no-edmm
WORKDIR /root/demos/minimap2/no-edmm/ws
RUN occlum init && rm -rf image
RUN copy_bom -f ../mini.yaml --root image --include-dir /opt/occlum/etc/template
COPY no_edmm.json /root/demos/minimap2/no-edmm/ws/Occlum.json
RUN occlum build

# Create the necessary directories for edmm
RUN mkdir -p /root/demos/minimap2/edmm/results
RUN mkdir -p /root/demos/minimap2/edmm/ws
COPY mini.yaml /root/demos/minimap2/edmm/mini.yaml

# Setup occlum workspace for edmm
WORKDIR /root/demos/minimap2/edmm/ws
RUN occlum init && rm -rf image
RUN copy_bom -f ../mini.yaml --root image --include-dir /opt/occlum/etc/template
COPY edmm.json /root/demos/minimap2/edmm/ws/Occlum.json
RUN ENABLE_EDMM=Y occlum build

WORKDIR /root/demos/minimap2
COPY perf.sh .
RUN chmod +x perf.sh

# Example of run with 16 threads and EDMM enabled
# RUN ENABLE_EDMM=Y occlum build
# RUN occlum run /bin/bowtie2-align-s -x "/minimap_input_files/index/hg38" -p "32" -1 "/minimap_input_files/reads/SRR31527206/1.fastq" -2 "/minimap_input_files/reads/SRR31527206/2.fastq" -S "/host/sample.sam"
