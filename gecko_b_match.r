library(Rsamtools)
library(Biostrings)
library(svMisc)

setwd('/Users/gerbix/Documents/vikas/gecko_green_monkey')

#gecko_b<-scanBam('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_20m.bam')
gecko_b<-scanBam('/Users/gerbix/Documents/vikas/gecko_green_monkey/gecko_b_20m.bam')

fasta_list<-list.files('/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_fastas', pattern = '*.fa$', full.names = TRUE)

dna = readDNAStringSet("/Users/gerbix/Documents/vikas/gecko_green_monkey/green_monkey_combined.fasta")

dna_names<-c()
for(i in 1:length(names(dna))){ 
  dna_names<-append(dna_names, strsplit(names(dna)[i], ' ')[[1]][1])
  }

with_pam_names<-c()
with_pam_seq<-c()
with_pam_names_rc<-c()
with_pam_seq_rc<-c()
without_pam_seq<-c()
without_pam_name<-c()
for (i in 1:length(gecko_b[[1]]$rname)){ 
  progress(i,31560)
  temp<-which( dna_names == gecko_b[[1]]$rname[i])
  temp_dna_seq<-as.character(substr(dna[temp,], gecko_b[[1]]$pos[i], (gecko_b[[1]]$pos[i] + 22)))
  revcomp<-(reverseComplement(DNAStringSet(as.character(substr(dna[temp,], gecko_b[[1]]$pos[i], (gecko_b[[1]]$pos[i] + 22))))))
  #print(as.character(revcomp[1]))
  #print(temp_dna_seq)
  temp_a<-paste0(gecko_b[[1]]$seq[i], 'AGG')
  temp_c<-paste0(gecko_b[[1]]$seq[i], 'CGG')
  temp_t<-paste0(gecko_b[[1]]$seq[i], 'TGG')
  temp_g<-paste0(gecko_b[[1]]$seq[i], 'GGG')
  
  if(grepl(temp_dna_seq, temp_a) |grepl(temp_dna_seq, temp_c) | grepl(temp_dna_seq, temp_t) | grepl(temp_dna_seq, temp_g)){ 
    #print('ok')
    with_pam_names<-append(with_pam_names, gecko_b[[1]]$qname[i])
    with_pam_seq<-append(with_pam_seq, temp_dna_seq)
  }
  else if(grepl(revcomp, temp_a) |grepl(revcomp, temp_c) | grepl(revcomp, temp_t) | grepl(revcomp, temp_g)){ 
    #print('rc')
    with_pam_names_rc<-append(with_pam_names_rc, gecko_b[[1]]$qname[i])
    with_pam_seq_rc<-append(with_pam_seq_rc, temp_dna_seq)
  }
  else{ 
    without_pam_name<-append(without_pam_name, gecko_b[[1]]$qname[i])
    without_pam_seq<-append(without_pam_seq, temp_dna_seq)
    }
}

with_pam<-data.frame(with_pam_names,with_pam_seq)
withoutpam<-data.frame(without_pam_name, without_pam_seq)

write.csv(with_pam,'gecko_b_with_pam.csv')
write.csv(withoutpam, 'gecko_b_without_pam.csv')
