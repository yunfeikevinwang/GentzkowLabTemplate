#!/bin/bash

unset run_latex
unset cleanup
run_latex() {

    # Get arguments
    programname=$(basename "$1" .tex)
    logfile="$2"

    # Set output directory
    # (If no third argument is provided, use the default)
    if [ -n "$3" ]; then
        outputdir="$3"
    else
        outputdir="../output"
    fi
    
    # Clean up
    cleanup() {
        mv "${programname}.pdf" ${outputdir}
        rm -f "${programname}.aux" \
              "${programname}.bbl" \
              "${programname}.blg" \
              "${programname}.log" \
              "${programname}.out" \
              "${programname}.fdb_latexmk" \
              "${programname}.fls" \
              "${programname}.synctex.gz" \
              "${programname}.nav" \
              "${programname}.snm" \
              "${programname}.toc"
    }

    # Ensure cleanup is called on exit
    trap 'cleanup' EXIT

    
    echo "Executing: latexmk ${programname}.tex -pdf -bibtex"
    (latexmk "${programname}.tex" -pdf -bibtex >> "${logfile}" 2>&1)

}

