#!/usr/bin/bash -l
#SBATCH -p short -c 24 --mem 24gb --out logs/ITSx_run.log

CPU=12
module load samtools
module load ITSx
mkdir -p results/ITSx
process() {
	genome=$1
	base=$2
	mkdir -p results/ITSx/$base
	cat results/ITS/$base.SSEARCH.tab | while read QUERY TARGET PID X GAPO GAPE QS QE TS TE EVALUE SCORE
	do
		samtools faidx $genome $TARGET 
	done > results/ITSx/$base/ITS_scaffolds.fasta
	ITSx -i results/ITSx/$base/ITS_scaffolds.fasta -t F -o results/ITSx/$base/ITSx
	perl -i -p -e "s/>/>${base}_/" results/ITSx/$base/ITSx.full.fasta results/ITSx/$base/ITSx.ITS[12].fasta 
}
export -f process
parallel -j $CPU process {} {/.} ::: $(ls genomes/*.fasta genomes/*.fna)

