#!/bin/sh

cp -r eBook src
cp images/* src/images
cp cover/* src/images
mv src/directory.md .
TOC="directory.md"
dos2unix src/*.md

sed -i 's#../images/#images/#g' src/*.md
cat >  src/frontmatter.md <<EOF
## 说明
本仓库仅使用 [PanBook](https://github.com/annProg/PanBook) 排版此电子书。

最新版本及问题反馈请访问 [上游仓库](https://github.com/Unknwon/the-way-to-go_ZH_CN)。


EOF

cat src/preface.md >> src/frontmatter.md
rm -f src/preface.md
mv src/Discussion_about_16.10.md src/backmatter.md

# 删除BOM
sed -i '1 s/^\xef\xbb\xbf//' src/*.md
sed -i $'1s/^\uFEFF//'  src/*.md

sed -i 's/# 前言/## 前言/g' src/frontmatter.md
sed -i 's/^### /> /g' src/frontmatter.md
sed -i '/- \[目录\].*/d' src/*.md
sed -i '/^- 上一.*/d' src/*.md
sed -i '/^- 下一.*/d' src/*.md
sed -i '/^## 链接/d' src/*.md

sed -i -r 's/^### [0-9]{1,2}\.[0-9]{1,2} (.*)/##### \1/g' src/*.md
sed -i -r 's/^## [0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2} (.*)/#### \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2} (.*)/## \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2}\.0 (.*)/## \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2}\.[0-9]{1,2} (.*)/### \1/g' src/*.md
sed -i -r 's/^# [0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2} (.*)/#### \1/g' src/*.md
sed -i -r 's/^# 总结/### 总结/g' src/11.13.md
sed -i -r 's/^## 练习/#### 练习/g' src/14.4.md

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