#!/usr/bin/bash -l
#SBATCH -p short -c 16 -N 1 -n 1 --mem 24gb 

module load mafft
module load fasttree
module load clipkit
mkdir -p aln

# full length
cat lib/ncbi_ref.ITSx.full.fasta results/ITSx/*/ITSx.full.fasta > aln/Rhodotorula_ITS_full.fas
mafft aln/Rhodotorula_ITS_full.fas > aln/Rhodotorula_ITS_full.fasaln
clipkit aln/Rhodotorula_ITS_full.fasaln

FastTreeMP -nt -gamma aln/Rhodotorula_ITS_full.fasaln.clipkit > aln/Rhodotorula_ITS_full.FT.tre

# ITS1 
cat lib/ncbi_ref.ITSx.ITS1.fasta results/ITSx/*/ITSx.ITS1.fasta > aln/Rhodotorula_ITS_ITS1.fas
mafft aln/Rhodotorula_ITS_ITS1.fas > aln/Rhodotorula_ITS_ITS1.fasaln
clipkit aln/Rhodotorula_ITS_ITS1.fasaln

FastTreeMP -nt -gamma aln/Rhodotorula_ITS_ITS1.fasaln.clipkit > aln/Rhodotorula_ITS_ITS1.FT.tre

# ITS2 
cat lib/ncbi_ref.ITSx.ITS2.fasta results/ITSx/*/ITSx.ITS2.fasta > aln/Rhodotorula_ITS_ITS2.fas
mafft aln/Rhodotorula_ITS_ITS2.fas > aln/Rhodotorula_ITS_ITS2.fasaln
clipkit aln/Rhodotorula_ITS_ITS2.fasaln

FastTreeMP -nt -gamma aln/Rhodotorula_ITS_ITS2.fasaln.clipkit > aln/Rhodotorula_ITS_ITS2.FT.tre
