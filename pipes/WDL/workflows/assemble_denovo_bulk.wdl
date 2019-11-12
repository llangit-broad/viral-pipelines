import "assemble_denovo.wdl" as assembly

workflow assemble_denovo_bulk {
  
  Array[File]+ reads_unmapped_bam_files

  scatter(reads_unmapped_bam in reads_unmapped_bam_files) {
    call sub.assemble_denovo {
      input: reads_unmapped_bam = reads_unmapped_bam
    }
  }
}