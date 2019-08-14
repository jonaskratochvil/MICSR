#!/bin/bash
# Copyright 2015-2016  Sarah Flora Juan
# Copyright 2016  Johns Hopkins University (Author: Yenda Trmal)
# Apache 2.0

set -e -o pipefail

data=/lnet/ms/data/cesky-rozhlas-prepisy/data/rozhlas_data/kaldi/cz_experiments/data
lm_dir=$data/lang_big

# To create G.fst from ARPA language model
. ./path.sh || die "path.sh expected";
# . ./env_voip_cs.sh
# . ./cmd.sh
# . ./path.sh
# . utils/parse_options.sh

echo "Building language model from training transcripts"

local/train_lms_srilm.sh --train-text $data/train/text $data/ $data/srilm_text

echo "Building language model from Europarlament text data"
# This gives some "timestamps" and shuffles it

#cp data/corpus.txt data/train/text_for_lm.txt
#cat /home/jkratochvil/personal_work_ms/00/lm_texts/DOMAIN_SPECIFIC_TXT.txt >> data/train/text_for_lm.txt

nl -nrz -w10  ../../../lm_texts/DOMAIN_SPECIFIC_TXT_NO_CORPUS.txt | utils/shuffle_list.pl > $data/local/domain_text

# Concatenate the domain specific and trascription texts
#cat data/train/text >> data/local/domain_text

local/train_lms_srilm.sh --train-text $data/local/domain_text $data/ $data/srilm_domain

echo "Building language model from General text data"

#nl -nrz -w10 /home/jkratochvil/personal_work_ms/00/lm_texts/GENERAL_TXT.txt \
#    | utils/shuffle_list.pl > $data/local/general_text
#local/train_lms_srilm.sh --train-text $data/local/general_text $data/ $data/srilm_general

# let's do ngram interpolation of the previous two LMs
# the lm.gz is always symlink to the model with the best perplexity, so we use that
# somehow add arguments from http://www.speech.sri.com/projects/srilm/manpages/ngram.1.html
# -mix-lm2 file , -mix-lambda2 weight
# These are the weights for the additional mixture components, corresponding to -mix-lm2 through -mix-lm9. The weight for the -mix-lm model is 1 minus the sum of -lambda and -mix-lambda2 through -mix-lambda9.

mkdir -p $data/srilm_interp
for w in 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1; do
    ngram -lm $data/srilm_domain/lm.gz  -mix-lm $data/srilm_text/lm.gz \
          -lambda $w -write-lm $data/srilm_interp/lm.${w}.gz
    echo -n "data/srilm_interp/lm.${w}.gz "
    ngram -lm $data/srilm_interp/lm.${w}.gz \
        -ppl /lnet/spec/work/people/jkratochvil/00/lm_texts/DEVELOPMENT.txt | paste -s -
done | sort  -k15,15g  > $data/srilm_interp/perplexities.txt

# This will take the LM with best development perplexity

[ -d $lm_dir ] && rm -rf $lm_dir
cp -R $data/lang $lm_dir
lm=$(cat data/srilm_interp/perplexities.txt | head -n1 | awk '{print $1}')
local/arpa2G.sh $lm $lm_dir $lm_dir

# Move the perplexities file and remove directories

cp $data/srilm_interp/perplexities.txt $lm_dir

rm -r $data/srilm_text $data/srilm_domain $data/srilm_interp

