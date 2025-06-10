#!/bin/bash
N_ITER=2
N_MIN_TH=1
N_MAX_TH=16
MSG_TOTAL_TIME="$N_ITER iterations, min $N_MIN_TH, max $N_MAX_TH threads"
RESULT_FOLDER="results"

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

# SMALL
echo "--------- start small -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
	# Create the directory to store results
	echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
	dir="$RESULT_FOLDER/small/perf_$(two_digit_form $c)TH/"
	mkdir -p ${dir}

	# Capture the start time
	start_time=$(date +%s)

	# Run Minimap2
	minimap2 -t $c -x sr /minimap_input_files/index/hg38.mmi /minimap_input_files/reads/SRR31527206/1.fastq /minimap_input_files/reads/SRR31527206/2.fastq > sample.sam

	# Capture the end time
	end_time=$(date +%s)

	# Calculate the elapsed time
	elapsed_time=$((end_time - start_time))

	# Save to file elapsed time
	echo "$elapsed_time" >> ${dir}execution_time.txt
	echo -e "#########\n#########" >> $RESULT_FOLDER/progress.txt
	((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo -e "$elapsed_total_time\n" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end small -----------" >> $RESULT_FOLDER/total_execution_time.txt

# BIG
echo "--------- start big -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
	# Create the directory to store results
	echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
	dir="$RESULT_FOLDER/big/perf_$(two_digit_form $c)TH/"
	mkdir -p ${dir}

	# Capture the start time
	start_time=$(date +%s)

	# Run Minimap2
	minimap2 -t $c -x sr /minimap_input_files/index/hg38.mmi /minimap_input_files/reads/SRR30170738/1.fastq /minimap_input_files/reads/SRR30170738/2.fastq > sample.sam

	# Capture the end time
	end_time=$(date +%s)

	# Calculate the elapsed time
	elapsed_time=$((end_time - start_time))

	# Save to file elapsed time
	echo "$elapsed_time" >> ${dir}execution_time.txt
	echo -e "#########\n#########" >> $RESULT_FOLDER/progress.txt
	((c=c*2))
done
done
total_end_time=$(date +%s)
elapsed_total_time=$((total_end_time - total_start_time))
echo -e "$elapsed_total_time\n" >> $RESULT_FOLDER/total_execution_time.txt
echo "--------- end big -----------" >> $RESULT_FOLDER/total_execution_time.txt