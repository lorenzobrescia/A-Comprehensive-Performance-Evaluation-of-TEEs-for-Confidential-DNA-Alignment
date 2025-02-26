#!/bin/bash
N_ITER=3
N_MIN_TH=1
N_MAX_TH=16
MSG_TOTAL_TIME="$N_ITER iterations, min $N_MIN_TH, max $N_MAX_TH threads"
RESULT_FOLDER="/root/demos/bowtie2/results"

# Function to transform number into 2 digit form with padding 0
function two_digit_form {
  number=$1
  if [ ${#number} -lt 2 ]; then
    number="0${number}"
  fi
  echo ${number}
}

mkdir -p "$RESULT_FOLDER"
echo "$MSG_TOTAL_TIME" >> $RESULT_FOLDER/total_execution_time.txt

#### no EDMM ####
cd no-edmm/ws/
echo "--------- start NO EDMM small -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/no-edmm/small/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    occlum run /bin/bowtie2-align-s -x "/bowtie_input_files/index/hg38" -p $c -1 "/bowtie_input_files/reads/SRR31527206/1.fastq" -2 "/bowtie_input_files/reads/SRR31527206/2.fastq" -S "/host/sample.sam"

    # Capture the end time
    end_time=$(date +%s)

    # Calculate the elapsed time
    elapsed_time=$((end_time - start_time))

    # Save to file elapsed time
    echo "$elapsed_time" >> ${dir}execution_time.txt
    echo -e "##################\n" >> $RESULT_FOLDER/progress.txt
    ((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo "$elapsed_total_time" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end NO EDMM small -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start NO EDMM big -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/no-edmm/big/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    occlum run /bin/bowtie2-align-s -x "/bowtie_input_files/index/hg38" -p $c -1 "/bowtie_input_files/reads/SRR30170738/1.fastq.gz" -2 "/bowtie_input_files/reads/SRR30170738/2.fastq.gz" -S "/host/sample.sam" 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Calculate the elapsed time
    elapsed_time=$((end_time - start_time))

    # Save to file elapsed time
    echo "$elapsed_time" >> ${dir}execution_time.txt
    echo -e "##################\n" >> $RESULT_FOLDER/progress.txt
    ((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo "$elapsed_total_time" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end NO EDMM big -----------" >> $RESULT_FOLDER/total_execution_time.txt

#### EDMM ####
cd ../../edmm/ws

echo "--------- start EDMM small -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/edmm/small/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    occlum run /bin/bowtie2-align-s -x "/bowtie_input_files/index/hg38" -p 16 -1 "/bowtie_input_files/reads/SRR31527206/1.fastq" -2 "/bowtie_input_files/reads/SRR31527206/2.fastq" -S "/host/sample.sam"

    # Capture the end time
    end_time=$(date +%s)

    # Calculate the elapsed time
    elapsed_time=$((end_time - start_time))

    # Save to file elapsed time
    echo "$elapsed_time" >> ${dir}execution_time.txt
    echo -e "##################\n" >> $RESULT_FOLDER/progress.txt
    ((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo "$elapsed_total_time" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end EDMM small -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start EDMM big -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/edmm/big/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    occlum run /bin/bowtie2-align-s -x "/bowtie_input_files/index/hg38" -p $c -1 "/bowtie_input_files/reads/SRR30170738/1.fastq.gz" -2 "/bowtie_input_files/reads/SRR30170738/2.fastq.gz" -S "/host/sample.sam" 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Calculate the elapsed time
    elapsed_time=$((end_time - start_time))

    # Save to file elapsed time
    echo "$elapsed_time" >> ${dir}execution_time.txt
    echo -e "##################\n" >> $RESULT_FOLDER/progress.txt
    ((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo "$elapsed_total_time" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end NO EDMM big -----------" >> $RESULT_FOLDER/total_execution_time.txt