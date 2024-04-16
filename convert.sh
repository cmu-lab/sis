#!/bin/bash

# 変換したいディレクトリのパスを指定
root_dir="./"

# テンプレートファイルのパス
template="./template.html"

# find コマンドで .md ファイルを探し、それぞれに対して pandoc を実行
find "$root_dir" -type f -name "*.md" -exec sh -c '
  for file do
    pandoc "$file" --template '"$template"' -o "${file%.md}.html" --wrap=none
  done
' sh {} +
