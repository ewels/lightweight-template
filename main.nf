#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FASTQC } from './modules/nf-core/fastqc/main'

Channel.fromPath(params.reads, checkIfExists: true)
    .map{ row -> tuple([id:row.baseName, single_end:true], row) }
    .set{ ch_reads }

workflow {
    FASTQC (ch_reads)
}
