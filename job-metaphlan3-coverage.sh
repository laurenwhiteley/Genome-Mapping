#load modules
module load anaconda3/2020.02
conda activate LaurenTools
#cutadapt (Add concatenate later)
fastq_filenames=($(ls *.fastq))
for i in "${fastq_filenames[@]}"
do
  i_basename=$(basename $i .fastq)
  echo "trimming adapters from $i_basename ..."
  cutadapt -a  AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -m 22 -o "$i_basename"_22bp.trim.fastq "$i_basename".fastq > "$i_basename"_22bp.cutadapt_log.txt
done
#mapping with bowtie2
trim_filenames=($(ls *.trim.fastq))
for i in "${trim_filenames[@]}"
do
  i_basename=$(basename $i .trim.fastq)
  echo "map to pseudomonas $i_basename ...."
  bowtie2 --end-to-end -p 16 -x <INSERT PATH 5> -q -U "$i_basename".trim.fastq PAo1_"$i_basename".sam 2>> PAo1_"$i_basename".bowtie_output.txt
  echo "map to staph $i.basename ..."
  bowtie2 --end-to-end -p 16 -x <INSERT PATH 6> -q -U "$i_basename".trim.fastq SA_"$i_basename".sam 2>> SA_"$i_basename".bowtie_output.txt  
done
#featureCounts
PAo1_sam_filenames=($(ls PAo1*.sam))
for i in "${PAo1_sam_filenames[@]}"
do
  i_basename=$(basename $i .sam)
  echo "counting features Pseudomonas $i_basename ..."
  <INSERT PATH 7> -a <INSERT PATH 8> -g locus -t CDS -o featurecounts_"$i_basename".txt "$i_basename".sam                                   
done
SA_sam_filenames=($(ls SA*.sam))
for i in "${SA_sam_filenames[@]}"
do
  i_basename=$(basename $i .sam)
  echo "counting features Staph $i_basename ..."
  <INSERT PATH 7> -a <INSERT PATH 9> -g Parent -t CDS -o featurecounts_"$i_basename".txt "$i_basename".sam
done
<INSERT PATH 7> -a <INSERT PATH 9> -g Parent -t CDS -o featurecounts_SA_summary_MW14.txt SA*.sam.sam
<INSERT PATH 7> -a <INSERT PATH 8> -g locus -t CDS -o featurecounts_PA_summary_MW14.txt PAo1*.sam
source <INSERT PATH 10>
source <INSERT PATH 11>
python3 <INSERT PATH 12>
python3 <INSERT PATH 13>
python3 <INSERT PATH 14>
python3 <INSERT PATH 15>
conda deactivate
conda activate metaphlan3
#mapping with metaphlan#
fullPath=$(pwd)
IFS='/' read -r -a fullPathArray <<< "$fullPath"
projectName=${fullPathArray[${#fullPathArray[@]}-1]}
cd <INSERT PATH 16>
mkdir "$projectName"
cd <INSERT PATH 17>
trim_filenames=($(ls *.trim.fastq))
for i in "${trim_filenames[@]}"
do
        i_basename=$(basename $i .trim.fastq)
        echo "metaphlan analysis of $i_basename ...."
        metaphlan "$i_basename".trim.fastq --input_type fastq --nproc 14 --read_min_len 22 --bowtie2db <INSERT PATH 17> > "$i_basename".bact_euk_profile.txt
done
python3 <INSERT PATH 18> *bact_euk_profile.txt > <INSERT PATH 17>/"$projectName"_merged_abundance_table.txt
cp *bact_euk_profile.txt *.csv *_merged_abundance_table.txt <INSERT PATH 16>/"$projectName"
