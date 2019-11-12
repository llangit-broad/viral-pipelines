import "tasks_taxon_filter.wdl" as taxon_filter
import "tasks_assembly.wdl" as assembly

workflow assemble_denovo {
  
  File reads_unmapped_bam
  File lastal_db_fasta
  Array[File]+ reference_genome_fasta
  trim_clip_db

  call taxon_filter.filter_to_taxon {
    input:
      reads_unmapped_bam = reads_unmapped_bam,
      lastal_db_fasta = lastal_db_fasta
  }

  call assembly.assemble {
    input:
      reads_unmapped_bam = filter_to_taxon.taxfilt_bam,
      trim_clip_db = trim_clip_db
  }

  call assembly.scaffold {
    input:
      contigs_fasta = assemble.contigs_fasta,
      reads_bam = filter_to_taxon.taxfilt_bam,
      reference_genome_fasta = reference_genome_fasta
  }

  call assembly.refine_2x_and_plot {
    input:
      assembly_fasta = scaffold.scaffold_fasta,
      reads_unmapped_bam = reads_unmapped_bam
  }
}