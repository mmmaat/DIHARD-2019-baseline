#!/bin/bash
#
# This script reproduces the baseline results within the provided
# docker container (see README.md for more details)


# directories specific to the docker setup. If running this script
# outside docker please adapt those paths.
KALDI=/kaldi
BASELINE=/baseline
DATA=/data

cp $BASELINE/run_notrain.sh $KALDI/egs/dihard_2018/v2
cd $KALDI/egs/dihard_2018/v2
local/make_dihard_2018_dev.sh $DATA data/dihard_2018_dev


# stage 0
./run_notrain.sh 0 || exit 1
cd $KALDI/egs/dihard_2018/v2
mkdir -p $nnet_dir
cp $BASELINE/{final.raw, max_chunk_size, min_chunk_size,extract.config} $nnet_dir

# stage 1
./run_notrain.sh 1 || exit 1
cp $BASELINE/plda $KALDI/egs/dihard_2018/v2/exp/xvector_nnet_1a/xvectors_dihard_2018_dev

# stage 2
./run_notrain.sh 2 || exit 1

# stage 3
./run_notrain.sh 3 || exit 1


exit 0
