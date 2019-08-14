#!/bin/bash

stage=4

. ./path.sh
. ./cmd.sh
# This requires text file (utt.wav text on one line), wav.scp, spk2utt, utt2spk, text2utt - vsechny tyto jen utt.wav utt.wav
if [ $stage -le 2 ]; then
    steps/make_mfcc.sh --cmd "$train_cmd" --nj 4 data/data_to_segment exp/make_mfcc_to_segment mfccs_to_segment
    steps/compute_cmvn_stats.sh data/data_to_segment exp/make_mfcc_to_segment mfccs_to_segment
fi
# This needs GPU both of them below, ssh to kronos, make sure that cmd.sh has --gpu x and submit through qsub -cwd -j y -pe smp x
if [ $stage -le 3 ]; then
    steps/cleanup/segment_long_utterances_nnet3.sh --nj 4 --cmd "$train_cmd" --extractor exp/nnet3/extractor exp/chain/tdnn1a_sp data/lang_chain \
        data/data_to_segment data/data_to_segment/text data/data_to_segment/utt2text data/data_segmented/ exp/data_segmented
fi

utils/fix_data_dir.sh data/data_segmented

if [ $stage -le 4 ]; then
    steps/cleanup/clean_and_segment_data_nnet3.sh  --nj 4 --cmd "$train_cmd" --extractor exp/nnet3/extractor data/data_segmented/ data/lang_chain exp/chain/tdnn1a_sp exp/tdnn1a_cleanup data/train_tdnn1_cleane
fi
