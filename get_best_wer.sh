#!/bin/bash

for x in exp/*/decode* exp/chain/*/decode*;do
    [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh
done
