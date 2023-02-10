#!/bin/bash
# bash is needed for "$@"

DISPLAY=:0 wmname LG3D
DISPLAY=:0 logisim-evolution "$@"
