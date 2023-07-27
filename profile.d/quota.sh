if [[ `id -u` -gt 10000 ]]; then
    stat $HOME/.quotareport > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        if [ -t 0 ]; then 
            cat $HOME/.quotareport
        fi
    fi
fi

