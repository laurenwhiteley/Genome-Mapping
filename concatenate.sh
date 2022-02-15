#!/usr/bin/env bash


### CONCATENATE FILES FROM BASESPACE FOLDERS ###
user_directory=${BASH_ARGV[0]}
find ./ -type f | grep -i gz$ | xargs -i cp {} ./

gunzip *_L00?_R1_001.fastq.gz


filenames_base=($(ls *_R1_001.fastq | awk '{a=substr($0, 1, length($0)-18); print a}' | sort | uniq))

for i in "${filenames_base[@]}"
do
  echo "processing $i sequences..."
  basename_count=$(ls $i"_L00"?"_R1_001.fastq"| wc -l);
  if [ $basename_count -eq 4 ]; then
    if [ ! -f $i'_L001_R1_001.fastq' ] || [ ! -f $i'_L002_R1_001.fastq' ] || [ ! -f $i'_L003_R1_001.fastq' ] || [ ! -f $i'_L004_R1_001.fastq' ]; then
      echo "There is something wrong with the filenames for $i! skipping..."
    else
      if [ -f $i'.fastq' ]; then
        echo "$i.fastq already exists! skipping..."
      else
        file1_length=$(grep -c @ $i"_L001_R1_001.fastq")
        file2_length=$(grep -c @ $i"_L002_R1_001.fastq")
        file3_length=$(grep -c @ $i"_L003_R1_001.fastq")
        file4_length=$(grep -c @ $i"_L004_R1_001.fastq")

        file1_hash=$( ls | grep $i"_L001_R1_001.fastq" | awk '{split($0, a, "."); print a[2]}' );
        file2_hash=$( ls | grep $i"_L002_R1_001.fastq" | awk '{split($0, a, "."); print a[2]}' );
        file3_hash=$( ls | grep $i"_L003_R1_001.fastq" | awk '{split($0, a, "."); print a[2]}' );
        file4_hash=$( ls | grep $i"_L004_R1_001.fastq" | awk '{split($0, a, "."); print a[2]}' );

        predicted_total=$(( $file1_length+$file2_length+$file3_length+$file4_length ))
        cat $i"_L001_R1_001.fastq" $i"_L002_R1_001.fastq" $i"_L003_R1_001.fastq" $i"_L004_R1_001.fastq" > $i".fastq"
        actual_total=$(grep -c @ $i".fastq")
        echo "$actual_total vs $predicted_total"
        if [ $predicted_total -eq $actual_total ]; then
          echo "$i successfully concatenated"
          rm $i"_L001_R1_001.fastq"
          rm $i"_L002_R1_001.fastq"
          rm $i"_L003_R1_001.fastq"
          rm $i"_L004_R1_001.fastq"
        else
          echo "ERROR in concatenating files to make $i.fastq. Final line sum is not what it should be. removing it..."
          rm $i".fastq"
        fi
      fi
    fi
  else
    echo "There are not 4 files for $i! skipping..."
  fi
done

