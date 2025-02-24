#!/usr/bin/env nextflow

nextflow.enable.dsl=2


process fastqcount {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    cpus 2
    memory '4 GB'
    input:
    file(fastq)

    output:
    file("output/*_count.txt")
    file("output/*_stat.txt")    

    """

    ~/fastqcount -i ${fastq} -o output/ -n ${fastq.simpleName}
    """
}

workflow {
    fastq_file = Channel.fromPath(params.fastq_source_folder+'/*.fq.gz', type: 'file')
    fastqcount(fastq_file)

}
