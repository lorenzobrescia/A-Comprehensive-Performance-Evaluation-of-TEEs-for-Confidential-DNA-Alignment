# Minimap2 in bare-metal
In order to run Minimap2 inside a machine, it is necessary to:

1. Download open input data
2. Execute Minimap2 on previuosly downloaded data within the CVM

# 1: Download Minimap2 input data
In order to work Minimap2 needs a reference genome and DNA sequences.

If you did not install [minimap2](https://github.com/lh3/minimap2) before, it could be necessary if you prefer to build the index reference by hand:
```bash
sudo apt install minimap2
# or: 
# curl -L https://github.com/lh3/minimap2/releases/download/v2.29/minimap2-2.29_x64-linux.tar.bz2 | tar -jxvf -
# add to path ./minimap2-2.29_x64-linux/minimap2
```

To build the reference genome, download it in `.fa` exetension and use `minimap2` tool to generate the structure:
```bash
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz
minimap2 -d hg38.mmi hg38.fa
```

Install and configure [SRA toolkit](https://github.com/ncbi/sra-tools/wiki):
```bash
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -vxzf sratoolkit.tar.gz
export PATH=$PWD/sratoolkit.3.2.1-ubuntu64/bin:$PATH

# If you want to configure the tool
vdb-config --interactive
```

Download [small input](https://trace.ncbi.nlm.nih.gov/Traces/index.html?view=run_browser&acc=SRR31527206&display=download) size (88MB):
```bash
prefetch SRR31527206
fasterq-dump SRR31527206

# Now you have pair SRR31527206_1.fastq and SRR31527206_2.fastq
```

Download [big input](https://trace.ncbi.nlm.nih.gov/Traces/index.html?view=run_browser&acc=SRR30170738&display=download) size (20G):
```bash
prefetch SRR30170738
fasterq-dump SRR30170738

# Now you have pair SRR31527206_1.fastq and SRR31527206_2.fastq
```

# 2: Execute Minimap2
Prepare all Minimap input files in a folder named `minimap_input_files/`
```bash
├── index
│   ├── hg38.mmi
│   ├── hg38.fa
└── reads
    ├── SRR30170738
    │   ├── 1.fastq
    │   └── 2.fastq
    ├── SRR31527206
        ├── 1.fastq
        └── 2.fastq
```

Then build the Docker image that will be able to launch the performance script `perf.sh`, the Dockerfile is provided in the current folder:
```bash
docker build -t bm-minimap:performance .
```

Finally run the container, attach to it and run the script.
```bash
docker run -itd --name bm bm-minimap:performance
docker attach bm
nohup ./perf.sh &
```