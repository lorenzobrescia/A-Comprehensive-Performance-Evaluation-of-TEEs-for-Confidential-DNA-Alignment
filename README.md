# A Comprehensive Performance Evaluation of TEEs for Confidential DNA Alignment

In this repository are present all the configurations in order to:

1. Run Bowtie2 with Docker in bare-metal, in Intel SGX enclaves (with Gramine and Occlum), in a legacy VM, in Intel TDX trust domain VM and in AMD SEV-SNP confidential VM;
1. Run Minimap2 with Docker in bare-metal, in Intel SGX enclaves (with Gramine and Occlum), in a legacy VM, in Intel TDX trust domain VM and in AMD SEV-SNP confidential VM;
1. Run VM microbenchmarks in an automated way and collect structured results.