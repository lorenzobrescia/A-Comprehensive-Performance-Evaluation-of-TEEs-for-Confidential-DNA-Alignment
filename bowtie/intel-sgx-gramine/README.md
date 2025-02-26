# Bowtie2
In order to run Bowtie2 inside a Gramine SGX Library OS, it is necessary to:

1. Download open input data
2. Execute Bowtie2 on previuosly downloaded data within the Gramine LibOS

# 1: Download Bowtie2 input data
In order to work Bowtie2 needs a reference genome and DNA sequences.

If you did not install [Bowtie2](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml) before, it could be necessary if you prefer to build the index reference by hand:
```bash
sudo apt install bowtie2
```

To build the reference genome, download it in `.fa` exetension and use `bowtie2-build` tool to generate the structure:
```bash
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz
bowtie2-build hg38.fa hg38
```

Install and configure [SRA toolkit](https://github.com/ncbi/sra-tools/wiki):
```bash
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -vxzf sratoolkit.tar.gz
export PATH=$PWD/sratoolkit.3.2.0-ubuntu64/bin:$PATH

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

# You can also compress these files
gzip -k SRR30170738_1.fastq
gzip -k SRR30170738_2.fastq
```

# 4: Execute Bowtie2 in Gramine LibOS
Prepare all Bowtie input files in a folder named `bowtie_input_files/`
```bash
├── index
│   ├── hg38.1.bt2
│   ├── hg38.2.bt2
│   ├── hg38.3.bt2
│   ├── hg38.4.bt2
│   ├── hg38.fa
│   ├── hg38.rev.1.bt2
│   └── hg38.rev.2.bt2
└── reads
    ├── SRR30170738
    │   ├── 1.fastq.gz
    │   └── 2.fastq.gz
    ├── SRR31527206
    │   ├── 1.fastq
    │   └── 2.fastq
```

Then build the Docker image that will be able to launch the performance script `perf.sh`, the Dockerfile is provided in the current folder:
```bash
docker build -t gramine:performance .
```

Finally run the container, attach to it and run the script.
```bash
docker run -itd --device /dev/sgx_enclave --name gramine --security-opt seccomp=unconfined gramine:performance 
docker attach gramine
nohup ./perf.sh &
```