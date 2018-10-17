#!/bin/bash

find ./ -type f -exec grep $1 '{}' ';' -print
