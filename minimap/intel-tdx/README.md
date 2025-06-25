# Minimap2
In order to run Minimap2 inside a TDX confidential VM (CVM), it is necessary to:

1. Setup host machine
2. Setup guest confidential VM
3. Download open input data
4. Execute Minimap2 on previuosly downloaded data within the CVM

# 1: Setup host

Clone the TDX repository, setup the host machine and shutdown:
```bash
git clone -b noble-24.04 https://github.com/canonical/tdx.git && cd tdx
sudo ./setup-tdx-host.sh
sudo shutdown
```

In the BIOS of the machine find these features:
```
Set Memory Encryption (TME) to Enable
Set Total Memory Encryption Bypass to Enable (Optional setting for best host OS and regular VM performance.)
Set Total Memory Encryption Multi-Tenant (TME-MT) to Enable
Set TME-MT memory integrity to Disable
Set Trust Domain Extension (TDX) to Enable
Set TDX Secure Arbitration Mode Loader (SEAM Loader) to Enable. (NOTE: This allows loading Intel TDX Loader and Intel TDX Module from the ESP or BIOS.)
Set TME-MT/TDX key split to a non-zero value
Set SW Guard Extensions (SGX) to Enable
```

Boot the machine and check if the host is correctly configured:
```bash
sudo dmesg | grep -i tdx
```

# 2: Setup guest CVM
Create a new VM:
```bash
cd tdx/guest-tools/image/
sudo ./create-td-image.sh -v 24.04
```

Boot the CVM, log to it and check TDX:
```bash
cd tdx/guest-tools
./run_td.sh

# Log to it with ssh

# Check tdx
sudo dmesg | grep -i tdx
```

Note: if you want to obtain comparable results between AMD and Intel CVMs you should use the same VM base image. For this reason, for the paper we start from the same VM image used in the AMD case, without creating a new one. So you can start from the same virtual disk and configure the TDX VM. In order to that you have to:

1. Boot the VM as you prefer (for example with qemu)
2. Setup the VM to arrange TDX:
```bash
git clone -b noble-24.04 https://github.com/canonical/tdx.git && cd tdx
sudo ./setup-tdx-guest.sh
sudo shutdown now
```

Boot the VM again and check if TDX is enabled
```bash
sudo dmesg | grep -i tdx
```

# 3: Download Minimap2 input data
In order to work Minimap2 needs a reference genome and DNA sequences.

If you did not install [minimap2](https://github.com/lh3/minimap2) before, it could be necessary if you prefer to build the index reference by hand:
```bash
sudo apt install minimap2
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
```

# 4: Execute Minimap2
Prepare all Bowtie input files in a folder named `minimap_input_files/`
```bash
├── index
│   ├── hg38.mmi
│   ├── hg38.fa
└── reads
    ├── SRR30170738
    │   ├── 1.fastq
    │   └── 2.fastq
    ├── SRR31527206
    │   ├── 1.fastq
    │   └── 2.fastq
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