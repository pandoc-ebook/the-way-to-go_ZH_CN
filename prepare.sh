#!/bin/sh

mv eBook src
mv images/* src/images
mv src/directory.md .
TOC="directory.md"

sed -i 's#../images/#images/#g' src/*.md
rm -f src/frontmatter.md
mv src/preface.md src/frontmatter.md
sed -i 's/# 前言/## 前言/g' src/frontmatter.md
sed -i '/- \[目录\].*/d' src/*.md
sed -i '/^- 上一.*/d' src/*.md
sed -i '/^- 下一.*/d' src/*.md
sed -i '/^## 链接/d' src/*.md

sed -i -r 's/^### [0-9]{1,2}\.[0-9]{1,2} (.*)/##### \1/g' src/*.md
sed -i -r 's/^## [0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2} (.*)/#### \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2}\.0 (.*)/# \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2}\.[0-9]{1,2} (.*)/## \1/g' src/*.md

sed -i -r 's/\?raw=true//g' src/*.md
sed -i -r 's/（\\n）/（`\\n`）/g' src/12.1.md
sed -i -r 's/\\r(.*和.*)\\n/\\\\r\1\\\\n/g' src/12.1.md
sed -i -r 's/行结束符 .\\n./行结束符 `\\n`/g' src/12.2.md
sed -i -r 's/行结束符是 \\n/行结束符是 `\\n`/g' src/12.2.md
sed -i -r 's/行结束符是 \\r\\n/行结束符是 `\\r\\n`/g' src/12.2.md
sed -i -r 's/\\n 就可以了/`\\n` 就可以了/g' src/12.2.md
sed -i -r 's/Newline（"\\n"）/Newline（`\\n`）/g' src/12.4.md

num=1
for id in `grep "[0-9]章" $TOC |awk '{print $2}'`;do
	[ $num -lt 10 ] && md="src/0${num}.0.md" || md="src/${num}.0.md"
	chapter="`grep $id $TOC |awk -F'：' '{print $2}'`"
	[ ! -f $md ] && echo "## $chapter" > $md && echo "write $md"
	((num=num+1))
done

for id in `grep "部分" $TOC |awk '{print $2}'`;do
	part="`grep $id $TOC|awk -F'：' '{print $2}'`"
	ch="`grep $id -A2 $TOC |tail -n 1 |sed -r 's/.*第([0-9]+)章.*/\1/g'`"
	[ $ch -lt 10 ] && md="src/0${ch}.0.md" || md="src/${ch}.0.md"

	sed -i "1i# $part" $md && echo "fix $md"
done