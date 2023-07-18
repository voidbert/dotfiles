#!/bin/bash

mkdir /tmp/nvim-latex || true
pdflatex -halt-on-error -output-directory /tmp/nvim-latex "$@" &> /tmp/nvim-latex/output

