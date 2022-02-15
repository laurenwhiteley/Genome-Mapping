#samtools view -@ 16 -bS SA_MW20-HLCW-9-1_S8_22bp.sam > SA_MW20-HLCW-9-1_S8_22bp.bam
#samtools sort -@ 16 -o SA_MW20-HLCW-9-1_S8_22bp.sorted.bam SA_MW20-HLCW-9-1_S8_22bp.bam
#samtools coverage -mA SA_MW20-HLCW-9-1_S8_22bp.sorted.bam
#samtools coverage -m -o SA_MW20-HLCW-9-1_S8_22bp_coverage.txt SA_MW20-HLCW-9-1_S8_22bp.sorted.bam
# make variable for filename and write a for loop to parse through the code #
PA_sam_filenames=($(ls PA*.sam))
for i in "${PA_sam_filenames[@]}"
do
    i_basename=$(basename $i _22bp.sam)
    echo "analyzing $i_basename ..."
    samtools view -@ 16 -bS "$i_basename"_22bp.sam > "$i_basename"_22bp.bam
    samtools sort -@ 16 -o "$i_basename"_22bp.sorted.bam "$i_basename"_22bp.bam
    samtools coverage -mA "$i_basename"_22bp.sorted.bam
    samtools coverage -m -o "$i_basename"_22bp_coverage.txt "$i_basename"_22bp.sorted.bam
done


