if (( ! $+commands[conda] )); then
    function anaconda_prompt_info() { }
else
    function anaconda_prompt_info(){
      if [[ -n $CONDA_DEFAULT_ENV ]]; then
          echo "%{$fg[cyan]%}$CONDA_DEFAULT_ENV "
      fi
    }

    _conda_active=0;

    function conda-activate {
        if [[ $conda_active == 1 ]]; then
            echo "deactivating $CONDA_DEFAULT_ENV"
            conda-deactivate
        fi
        _CONDA_OLD_PATH=$PATH
        conda_active=1;
        export PATH=$(conda ..activate "$@")
        export CONDA_DEFAULT_ENV="$@"
        rehash
    }

    function conda-deactivate {
        if [[ $conda_active == 1 ]]; then
            export PATH=$_CONDA_OLD_PATH
            unset CONDA_DEFAULT_ENV
            conda_active=0
            rehash
        fi
    }
fi
