#!/usr/bin/env bash

echo "Update micro text editor plugins..."
micro -plugin update

echo "Install micro text editor plugins..."
micro -plugin install misspell
micro -plugin install editorconfig
micro -plugin install comment
micro -plugin install filemanager
micro -plugin install manipulator
