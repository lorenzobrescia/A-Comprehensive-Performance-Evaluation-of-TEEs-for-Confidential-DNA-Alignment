#!/bin/bash
N_ITER=1
N_MIN_TH=1
N_MAX_TH=1
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


cd small/
echo "--------- start SMALL DIRECT -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/DIRECT/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Create manifest.sgx
    make ths=$c

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    gramine-direct bow 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Clear manifest files
    make clean

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
echo "--------- end SMALL DIRECT -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start SMALL 8G -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
	# Create the directory to store results
	echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
	dir="$RESULT_FOLDER/8G/perf_$(two_digit_form $c)TH/"
	mkdir -p ${dir}

  # Create manifest.sgx
  make ths=$c

	# Capture the start time
	start_time=$(date +%s)

	# Run Bowtie2
	gramine-sgx bow 2>> $RESULT_FOLDER/alignment_stats.txt

	# Capture the end time
	end_time=$(date +%s)

  # Clear manifest files
  make clean

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
echo "--------- end SMALL 8G -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start SMALL EDMM -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/EDMM/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Create manifest.sgx
    make ths=$c edmm=1

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    gramine-sgx bow 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Clear manifest files
    make clean

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
echo "--------- end SMALL EDMM -----------" >> $RESULT_FOLDER/total_execution_time.txt

# BIG

cd ../big
echo "--------- start BIG DIRECT -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/DIRECT/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Create manifest.sgx
    make ths=$c

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    gramine-direct bow 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Clear manifest files
    make clean

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
echo "--------- end BIG DIRECT -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start BIG 8G -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
	# Create the directory to store results
	echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
	dir="$RESULT_FOLDER/8G/perf_$(two_digit_form $c)TH/"
	mkdir -p ${dir}

  # Create manifest.sgx
  make ths=$c

	# Capture the start time
	start_time=$(date +%s)

	# Run Bowtie2
	gramine-sgx bow 2>> $RESULT_FOLDER/alignment_stats.txt

	# Capture the end time
	end_time=$(date +%s)

  # Clear manifest files
  make clean

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
echo "--------- end BIG 8G -----------" >> $RESULT_FOLDER/total_execution_time.txt


echo "--------- start BIG EDMM -----------" >> $RESULT_FOLDER/total_execution_time.txt
total_start_time=$(date +%s)
for ((i=1; i<=$N_ITER; i++))
do
c=$N_MIN_TH
while [ $c -le $N_MAX_TH ]
do
    # Create the directory to store results
    echo "Iteration $i, number of threads $c" >> $RESULT_FOLDER/stat.txt
    dir="$RESULT_FOLDER/EDMM/perf_$(two_digit_form $c)TH/"
    mkdir -p ${dir}

    # Create manifest.sgx
    make ths=$c edmm=1

    # Capture the start time
    start_time=$(date +%s)

    # Run Bowtie2
    gramine-sgx bow 2>> $RESULT_FOLDER/alignment_stats.txt

    # Capture the end time
    end_time=$(date +%s)

    # Clear manifest files
    make clean

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
echo "--------- end BIG EDMM -----------" >> $RESULT_FOLDER/total_execution_time.txt