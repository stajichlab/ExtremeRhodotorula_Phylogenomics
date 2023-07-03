#!/usr/bin/bash -l
#SBATCH -p short -c 24 -N 1 -n 1  --mem 8gb

module load bioperl
module load parallel

for m in $(ls ../ExtremeRhodotorula_DraftGenomes/annotation/*/predict_results/*.cds-transcripts.fa ../Ref_genomes/annotation/*/predict_results/*.cds-transcripts.fa)
do
	name=$(basename $m .cds-transcripts.fa)
	cdsname=$(basename $m)
	if [[ ! -f cds/$cdsname || $m -nt cds/$cdsname ]];
	then
		echo $name
		perl -p -e 's/^>([^_]+)_/>$1|$1_/' $m > cds/$cdsname
	fi
	if [ ! -f Phylogeny/cds/$name.cds.fa ]; then
		ln -s ../../cds/$cdsname Phylogeny/cds/$name.cds.fa
	fi
done

translate() {
	in=$(basename $1 .cds.fa)
	if [[ ! -s pep/$in.pep.fa || $1 -nt pep/$in.pep.fa ]]; then
		bp_translate_seq $1 > pep/$in.pep.fa
	fi
}
export -f translate
pushd Phylogeny
parallel -j 24 translate ::: $(ls cds/*.cds.fa)
