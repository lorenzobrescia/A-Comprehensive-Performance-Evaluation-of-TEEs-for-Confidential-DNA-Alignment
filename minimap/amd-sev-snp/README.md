# Minimap2 in SEV-SNP
In order to run Minimap2 inside a SEV-SNP confidential VM (CVM), it is necessary to:

1. Setup host machine
2. Setup guest confidential VM
3. Download open input data
4. Execute Minimap2 on previuosly downloaded data within the CVM

# 1: Setup host

In the BIOS of the machines find these features:
```
SEV-ES ASID space Limit Control -> Manual
SEV-ES ASID space limit -> 100
SNP Memory Coverage -> Enabled 
SMEE -> Enabled
SEV-SNP -> Enabled
```

Install necessary packages:
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential gcc python3-pip iasl pkg-config glib-2.0 python-is-python3 libncurses-dev nasm bison flex libssl-dev libelf-dev virt-manager guestfs-tools openssh
sudo apt-get install -y debhelper-compat=12
sudo pip3 install meson virtualenv toil sphinx ninja
```

Clone the AMD repository and move to the SNP branch:
```bash
git clone https://github.com/AMDESE/AMDSEV.git && cd AMDSEV
git checkout snp-latest
```

Build all the necessary binaries:
```bash
./build.sh --package
```

Install the Linux kernel on the host machine:
```bash
cd snp-release-<date>
./install.sh
```

At this point reboot and check if the kernel is changed and if SEV features are enabled:
```bash
uname -r
# kernel .rc

sudo dmesg | grep -i -e rmp -e sev
# [    0.000000] SEV-SNP: RMP table physical range [0x0000000094200000 - 0x00000000a47fffff]
# [   18.478643] ccp 0000:02:00.5: sev enabled
# [   19.340320] ccp 0000:02:00.5: SEV API:1.55 build:24
# [   19.340339] ccp 0000:02:00.5: SEV-SNP API:1.55 build:24
# [   19.347968] kvm_amd: SEV enabled (ASIDs 99 - 1006)
# [   19.347970] kvm_amd: SEV-ES enabled (ASIDs 1 - 98)
# [   19.347972] kvm_amd: SEV-SNP enabled (ASIDs 1 - 98)
```

An alternative way is to install the mainline kernel starting from v6.11, where all the features for SEV-SNP should be already implemented.

# 2: Setup guest CVM
Download an image of Ubuntu, for example `ubuntu-24.04.2-live-server-amd64.iso`:
```bash
wget https://releases.ubuntu.com/24.04/ubuntu-24.04.2-live-server-amd64.iso
```

Create an empty virtual disk:
```bash
# From top level directory of cloned AMDSEV.git
./usr/local/bin/qemu-img create -f qcow2 DISK_NAME 70G
```

Install the operating system inside the VM:
```bash
sudo ./launch-qemu.sh -hda DISK_NAME -cdrom PATH_TO_ubuntu-24.04.2-live-server-amd64.iso -default-network

# If you want a terminal:
# edit grub menu with 'e' adding this: console=ttyS0,115200n8
# then ctrl + x
# Finally, end the installation of the VM and shutdown it
```

Launch the VM
```bash
sudo ./launch-qemu.sh -hda DISK_NAME -default-network
```

Host side, copy previuos kernel prebuilt packages to the guest:
```bash
scp snp-release-DATE.tar.gz USER@localhost:/PATH
```

In the VM install the kernel and shutdown the machine:
```bash
# Install the guest kernel
tar zxvf snp-release-DATE.tar.gz 
cd snp-release-DATE/linux/guest
sudo dpkg -i *.deb
sudo shutdown now
```

Now to launch the VM with SEV-SNP it is necessary to give this command:
```bash
sudo ./launch-qemu.sh -hda DISK_NAME -default-network -sev-snp

# Check if SEV-SNP enabled
sudo dmesg | grep -i snp
```

# 3: Download Minimap2 input data
In order to work Minimap2 needs a reference genome and DNA sequences.

If you did not install [Minimap2](https://github.com/lh3/minimap2) before, it could be necessary if you prefer to build the index reference by hand:
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

# Now you have pair SRR31527206_1.fastq and SRR31527206_2.fastq
```

# 4: Execute Minimap2 in the SNP VM
Boot the SNP VM and prepare all Bowtie input files in a folder named `bowtie_input_files/`
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