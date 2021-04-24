#!/usr/bin/env sh

out=""

for arg in "$@"
do
    case $arg in
        "-debug");;
        "--debug");;
        *)
            if [[ $* == *-debug* || $* == *--debug* ]]
            then
                nasm -g -f elf64 -F dwarf $arg.asm
            else
                nasm -f elf64 -F dwarf $arg.asm
            fi

            out+=" "$arg.o
        ;;
    esac
done

if [[ $* == *-debug* || $* == *--debug* ]]
then
    gcc -no-pie -m64 -g -o $1 $out && gdb -tui $1
else
    gcc -no-pie -m64 -o $1 $out && ./$1
fi
