export KALDI_ROOT=`pwd`/../..

[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
export PATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$PWD:$PATH
[ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
. $KALDI_ROOT/tools/config/common_path.sh

# SRILM is needed for LM model building
SRILM_ROOT=$KALDI_ROOT/tools/srilm
SRILM_PATH=$SRILM_ROOT/bin:$SRILM_ROOT/bin/i686-m64
export PATH=$PATH:$SRILM_PATH

export LC_ALL=C

### CUDA ###
CUDNN_version=7.0
CUDA_version=9.2  # alternatives 8.0 9.0 9.1 9.2
CUDA_DIR_OPT=/opt/cuda/$CUDA_version

# If directory /opt/cuda/9.2 exists than proceed
if [ -d "$CUDA_DIR_OPT" ] ; then
    CUDA_DIR=$CUDA_DIR_OPT
    export CUDA_HOME=$CUDA_DIR
    export THEANO_FLAGS="cuda.root=$CUDA_HOME,device=gpu,floatX=float32"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_DIR/cudnn/$CUDNN_version/lib64:$CUDA_DIR/lib64:$LD_LIBRARY_PATH
    export PATH=$PATH:$CUDA_DIR/bin:$CUDA_DIR/lib64:$PATH
    export CPATH=$CUDA_DIR/cudnn/$CUDNN_version/include:$CPATH
fi

#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
#export PATH=/usr/local/cuda-8.0/bin:$PATH

#source /opt/intel/mkl/bin/mklvars.sh intel64

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_DIR/cudnn/$CUDNN_version/lib64:$CUDA_DIR/lib64
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/mkl/lib/intel64/
#export LD_LIBRARY_PATH="$KALDI_ROOT/src/lib"
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KALDI_ROOT/tools/openfst/lib

