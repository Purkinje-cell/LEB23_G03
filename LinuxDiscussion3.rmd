---
title: "第四次讨论"
author: "执笔：王沛雨 孙伟棠"
date: "2023-03-30"
output: 
  rmdformats::downcute:
    self_contained: true
    lightbox: true
    gallery: false
    highlight: tango
---



## LEB03组第三次讨论报告

[TOC]

### 关于`HMMER`的使用

#### 基本介绍

调用服务器上的默认环境下`HMMER`软件：

根据`HMMER`官网的结果，目前最新的版本为`v4.3.2`，而服务器上根据`hmmbuild -h`得到的默认版本为`v3.1b`，故使用`conda`安装最新版的`HMMER`，具体代码如下：

```bash
conda create -n hmmer hmmer=3.3.2 # create hmmer environment
conda activate hmmer
hmmbuild -h # version output: v3.3.2
```

安装后，查看`HMMER`官网的官方document：[点击进入](http://eddylab.org/software/hmmer/Userguide.pdf)

根据`HMMER`描述，它是一款用概率统计模型构建概蛋白、DNA序列结构域族的软件，可以完成的工作有：

* 查找精准的同源序列
* 查找单一序列的同源序列
* 蛋白质结构域的自动注释
* 深度比对结果的聚簇

用于实现以上功能的软件包括如下18个：

![soft](C:\Users\SWT\Desktop\hmmersoft.png)

其中，`hmmbuild`，`hmmsearch`，`hmmscan`和`hmmalign`包含蛋白质结构域分析与注释的主要流程，比如用数据库如`Pfam`

> `Pfam`数据库系统由剑桥大学开发，收集蛋白质家族和蛋白质结构域的信息，可以对蛋白质进行结构和功能、进化分析等，应用于蛋白质结构功能预测、基因组注释和系统生物学研究。

而`phmmer`和`jackhmmer`搜索单个蛋白质序列，类似`BLASTP`和`PSI-BLAST`，`nhmmer`则是能够搜索长、染色体级别的DNA序列，`nhmmscan`能够根据DNA序列搜索蛋白质数据库。

**这里有一个问题，根据官网文献，在HMMER安装的目录下应存在一个`tutorial`目录，包括其测试样例数据，但是我们从`conda`的安装目录中没有找到，从服务器的默认目录也没有找到**

#### 使用技巧

`HMMER`支持UNIX系统的管道数据传输，需要用`‘-’`来标识传入的文件名称，例如：

```bash
hmmsearch globins64.hmm uniprot_sprot.fasta
cat globins4.hmm | hmmsearch - uniprot_sprot.fast
cat uniprot_sprot.fasta | hmmsearch globins4.hmm
```

用on-the-fly的方式创建子序列请求：

```bash
cat mytargs.list | hmmfetch -f Pfam.hmm - | hmmsearch - uniprot_sprot.fasta
```

对于`.gz`结尾的压缩格式，`HMMER`程序能够直接阅读并及时地解压缩他们再进行处理，需要`gunzip`（默认包含）作为依赖

#### 使用案例
#样例数据的试运行：对globin4数据的分析
从 https://github.com/EddyRivasLab/hmmer/tree/master/tutorial 获取测试数据globin4.sto
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
打印观察数据，发现globin4.sto由HBB_HUMAN、HBA_HUMAN、MYG_PHYCA、GLB5_PETMA四种球蛋白的比对后的部分序列组成
```{r see globin4.sto ,eval=FALSE}
(base) leb3b@bbt:~/0330$ cat globin4.sto
# STOCKHOLM 1.0

HBB_HUMAN   ........VHLTPEEKSAVTALWGKV....NVDEVGGEALGRLLVVYPWTQRFFESFGDLSTPDAVMGNPKVKAHGKKVL
HBA_HUMAN   .........VLSPADKTNVKAAWGKVGA..HAGEYGAEALERMFLSFPTTKTYFPHF.DLS.....HGSAQVKGHGKKVA
MYG_PHYCA   .........VLSEGEWQLVLHVWAKVEA..DVAGHGQDILIRLFKSHPETLEKFDRFKHLKTEAEMKASEDLKKHGVTVL
GLB5_PETMA  PIVDTGSVAPLSAAEKTKIRSAWAPVYS..TYETSGVDILVKFFTSTPAAQEFFPKFKGLTTADQLKKSADVRWHAERII

HBB_HUMAN   GAFSDGLAHL...D..NLKGTFATLSELHCDKL..HVDPENFRLLGNVLVCVLAHHFGKEFTPPVQAAYQKVVAGVANAL
HBA_HUMAN   DALTNAVAHV...D..DMPNALSALSDLHAHKL..RVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVL
MYG_PHYCA   TALGAILKK....K.GHHEAELKPLAQSHATKH..KIPIKYLEFISEAIIHVLHSRHPGDFGADAQGAMNKALELFRKDI
GLB5_PETMA  NAVNDAVASM..DDTEKMSMKLRDLSGKHAKSF..QVDPQYFKVLAAVIADTVAAG.........DAGFEKLMSMICILL

HBB_HUMAN   AHKYH......
HBA_HUMAN   TSKYR......
MYG_PHYCA   AAKYKELGYQG
GLB5_PETMA  RSAY.......
//
```
先建立profile 文件名：globin4.hmm
```{r make profile ,eval=FALSE}
(base) leb3b@bbt:~/0330$ hmmbuild globin4.hmm globin4.sto
# hmmbuild :: profile HMM construction from multiple sequence alignments
# HMMER 3.3.2 (Nov 2020); http://hmmer.org/
# Copyright (C) 2020 Howard Hughes Medical Institute.
# Freely distributed under the BSD open source license.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# input alignment file:             globin4.sto
# output HMM file:                  globin4.hmm
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# idx name                  nseq  alen  mlen eff_nseq re/pos description
#---- -------------------- ----- ----- ----- -------- ------ -----------
1     globin4                  4   171   149     0.96  0.589

#
```
    
运行结果显示共有4条序列
alen表示比对长度，mlen表示共有序列的长度
eff_nseq表示比对的效率，re/pos 表示两个函数或概率的相对熵值，差异越大则熵越大，完全相同则熵为0

less查看hmm文件
```{r make hmm,eval=FALSE}
HMMER3/f [3.3.2 | Nov 2020]
NAME  globin4
LENG  149
ALPH  amino
RF    no
MM    no
CONS  yes
CS    no
MAP   yes
DATE  Thu Mar 30 16:16:10 2023
NSEQ  4
EFFN  0.964844
CKSUM 2027839109
STATS LOCAL MSV       -9.8664  0.70955
STATS LOCAL VITERBI  -10.7223  0.70955
STATS LOCAL FORWARD   -4.1641  0.70955
HMM          A        C        D        E        F        G        H        I        K        L        M        N        P        Q        R        S        T        V        W        Y
            m->m     m->i     m->d     i->m     i->i     d->m     d->d
  COMPO   2.36800  4.52198  2.96929  2.70577  3.20715  3.01836  3.40293  2.90711  2.55482  2.34699  3.67768  3.19591  3.45289  3.16361  3.08198  2.67062  2.85417  2.56574  4.55599  3.63079
          2.68638  4.42245  2.77499  2.73143  3.46374  2.40505  3.72514  3.29307  2.67761  2.69375  4.24709  2.90366  2.73721  3.18166  2.89820  2.37880  2.77499  2.98440  4.58497  3.61523
          0.55970  1.87270  1.29132  1.73023  0.19509  0.00000        *
      1   1.75819  4.17850  3.77264  3.37715  3.71018  3.31297  4.28273  2.37054  3.30099  2.52201  3.62331  3.56321  3.94404  3.62536  3.57311  2.73559  2.84831  1.62714  5.32308  4.09587      9 v - - -
          2.68618  4.42225  2.77519  2.73123  3.46354  2.40513  3.72494  3.29354  2.67741  2.69355  4.24690  2.90347  2.73739  3.18146  2.89801  2.37887  2.77519  2.98518  4.58477  3.61503
          0.03182  3.85936  4.58171  0.61958  0.77255  0.34183  1.23951
      2   2.62833  4.47006  3.32205  2.82847  3.63376  3.49826  2.70724  3.02941  2.75408  2.74418  3.64789  3.24903  2.69825  3.12221  3.11180  2.79427  2.89380  1.86602  5.05970  3.76787     10 v - - -
          2.68618  4.42225  2.77519  2.73123  3.46354  2.40513  3.72494  3.29354  2.67741  2.69355  4.24690  2.90347  2.73739  3.18146  2.89801  2.37887  2.77519  2.98518  4.58477  3.61503
          0.02321  4.17053  4.89288  0.61958  0.77255  0.48576  0.95510
      3   3.50771  4.88753  4.66754  4.31907  3.27776  4.35743  4.88268  2.50779  4.08449  0.57907  3.22569  4.56607  4.74802  4.37991  4.20749  3.97946  3.79191  2.62059  5.25407  4.04279     11 L - - -
          2.68618  4.42225  2.77519  2.73123  3.46354  2.40513  3.72494  3.29354  2.67741  2.69355  4.24690  2.90347  2.73739  3.18146  2.89801  2.37887  2.77519  2.98518  4.58477  3.61503
          0.02321  4.17053  4.89288  0.61958  0.77255  0.48576  0.95510
      4   2.34111  4.28748  3.51587  3.21760  4.36970  3.06332  4.28987  3.74396  3.23937  3.46805  4.31385  3.39181  3.80269  3.55639  3.55063  1.10193  1.96408  3.23023  5.71943  4.49082     12 s - - -
          2.68618  4.42225  2.77519  2.73123  3.46354  2.40513  3.72494  3.29354  2.67741  2.69355  4.24690  2.90347  2.73739  3.18146  2.89801  2.37887  2.77519  2.98518  4.58477  3.61503
          0.02321  4.17053  4.89288  0.61958  0.77255  0.48576  0.95510
      5   2.08645  4.88226  2.76555  1.92911  4.33063  3.33581  3.78790  3.73824  2.62367  3.34530  4.17189  2.96745  2.11202  2.95012  3.08047  2.70587  2.97273  3.36490  5.57314  4.22372     13 e - - -
          2.68618  4.42225  2.77519  2.73123  3.46354  2.40513  3.72494  3.29354  2.67741  2.69355  4.24690  2.90347  2.73739  3.18146  2.89801  2.37887  2.77519  2.98518  4.58477  3.61503
          0.02321  4.17053  4.89288  0.61958  0.77255  0.48576  0.95510
      6   1.69820  4.80882  2.77457  1.97347  4.35553  2.28499  3.84394  3.77021  2.71313  3.38434  4.21011  2.99279  3.85574  3.01647  3.17214  2.68980  2.96833  3.37473  5.61184  4.27002 
```
hmm文件中，
LENG表示模型中匹配状态的数量
DATE  创建的日期和时间
NSEQ表示序列号
EFFN  有效序列号，确定的有效序列总数
CKSUM是非负无符号32位整数，根据训练数据计算所得
STATS 是E值计算的统计参数 第二位为对齐模式配置
MSV、VITERBI和FORWARD是分数分布的名称
之后的两个数是分别控制每个分布的位置和斜率的两个参数

下方矩阵的值为：每三行为一个有数字标号的大行，每个大行表示序列的一位。每一大行包括三小行，第一行为该位m时各个氨基酸出现的概率，第二行表示各个位上发生i时每种氨基酸出现的概率，观察发现每一大行的第二小行值是相同的。第三行为状态转移矩阵中i/m/d之间变化的值，注意到i和d之间没有转化，因为序列中不允许出现缺失和插入相连的情况。

建立到本地uniprot的软连接，以方便进行数据库中的比对
```{r make softlink0 ,eval=FALSE}
ln -s /rd1/home/public/HMMER/uniprot_sprot.fasta
```
    

发现软链接不可用，服务器中HMMER文件夹下uniprot_sprot.fasta为指向原位置（../blast_data/swiss-prot/uniprot_sprot.fasta)的软链接，而原文件位置已经移动到了新位置/rd1/home/public/BLAST/BLAST_DB/uniprot_sprot.fasta。
![figure 1 HEMMER文件夹下的软链接错误](C:\Users\SWT\Desktop\Screenshot 2023-03-30 165013.png)
    
重新创建软连接至uniprot_sprot.fasta

```{r make softlink1 ,eval=FALSE}
ln -s /rd1/home/public/BLAST/BLAST_DB/uniprot_sprot.fasta

```

使用命令hmmsearch 在uniport 数据库中根据已经生成的隐马尔科夫模型寻找同源序列
```{r hmmsearch ,eval=FALSE}
hmmsearch globins4.hmm uniprot_sprot.fasta > globins4.search.out
less globins4.search.out
```
运行的结果如下
```{r show query ,eval=FALSE}
# hmmsearch :: search profile(s) against a sequence database
# HMMER 3.3.2 (Nov 2020); http://hmmer.org/
# Copyright (C) 2020 Howard Hughes Medical Institute.
# Freely distributed under the BSD open source license.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# query HMM file:                  globin4.hmm
# target sequence database:        uniprot_sprot.fasta
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Query:       globin4  [M=149]
Scores for complete sequences (score includes all domains):
   --- full sequence ---   --- best 1 domain ---    -#dom-
    E-value  score  bias    E-value  score  bias    exp  N  Sequence              Description
    ------- ------ -----    ------- ------ -----   ---- --  --------              -----------
    4.9e-65  223.2   0.1    5.5e-65  223.0   0.1    1.0  1  sp|P02024|HBB_GORGO    Hemoglobin subunit beta OS=Gorilla gor
    6.9e-65  222.7   0.1    7.7e-65  222.6   0.1    1.0  1  sp|P68871|HBB_HUMAN    Hemoglobin subunit beta OS=Homo sapien
    6.9e-65  222.7   0.1    7.7e-65  222.6   0.1    1.0  1  sp|P68872|HBB_PANPA    Hemoglobin subunit beta OS=Pan paniscu
    6.9e-65  222.7   0.1    7.7e-65  222.6   0.1    1.0  1  sp|P68873|HBB_PANTR    Hemoglobin subunit beta OS=Pan troglod
    1.2e-64  222.0   0.1    1.3e-64  221.8   0.1    1.0  1  sp|P02025|HBB_HYLLA    Hemoglobin subunit beta OS=Hylobates l
    2.1e-64  221.2   0.2    2.3e-64  221.0   0.2    1.0  1  sp|P02033|HBB_PILBA    Hemoglobin subunit beta OS=Piliocolobu
    2.2e-64  221.1   3.3    2.5e-64  220.9   3.3    1.0  1  sp|P02185|MYG_PHYMC    Myoglobin OS=Physeter macrocephalus OX
    9.2e-64  219.1   0.1      1e-63  218.9   0.1    1.0  1  sp|P02028|HBB_CHLAE    Hemoglobin subunit beta OS=Chlorocebus
    1.4e-63  218.5   0.2    1.6e-63  218.3   0.2    1.0  1  sp|P02040|HBB_CEBAL    Hemoglobin subunit beta OS=Cebus albif
    1.8e-63  218.1   0.1      2e-63  218.0   0.1    1.0  1  sp|P02032|HBB_SEMEN    Hemoglobin subunit beta OS=Semnopithec
      2e-63  218.0   0.2    2.3e-63  217.8   0.2    1.0  1  sp|Q6WN25|HBB_LAGLA    Hemoglobin subunit beta OS=Lagothrix l
    2.4e-63  217.7   0.2    2.7e-63  217.6   0.2    1.0  1  sp|P19885|HBB_COLPO    Hemoglobin subunit beta OS=Colobus pol
    2.5e-63  217.7   0.1    2.7e-63  217.5   0.1    1.0  1  sp|P08259|HBB_MANSP    Hemoglobin subunit beta OS=Mandrillus
    2.6e-63  217.6   0.2    2.9e-63  217.5   0.2    1.0  1  sp|P67821|HBB_SAPAP    Hemoglobin subunit beta OS=Sapajus ape
    3.1e-63  217.4   0.2    3.5e-63  217.2   0.2    1.0  1  sp|P67822|HBB_CEBCA    Hemoglobin subunit beta OS=Cebus capuc
    5.9e-63  216.5   1.0    6.5e-63  216.3   1.0    1.0  1  sp|P13557|HBB_CARSF    Hemoglobin subunit beta OS=Carlito syr
      7e-63  216.2   0.1    7.8e-63  216.1   0.1    1.0  1  sp|P02030|HBB_PAPCY    Hemoglobin subunit beta OS=Papio cynoc
    7.2e-63  216.2   0.1      8e-63  216.0   0.1    1.0  1  sp|Q9TSP1|HBB_PAPAN    Hemoglobin subunit beta OS=Papio anubi
    7.9e-63  216.0   0.1    8.8e-63  215.9   0.1    1.0  1  sp|P68222|HBB_MACFU    Hemoglobin subunit beta OS=Macaca fusc
    7.9e-63  216.0   0.1    8.8e-63  215.9   0.1    1.0  1  sp|P68223|HBB_MACFA    Hemoglobin subunit beta OS=Macaca fasc
    7.9e-63  216.0   0.1    8.8e-63  215.9   0.1    1.0  1  sp|P68224|HBB_MACSP    Hemoglobin subunit beta OS=Macaca spec

```
找到的数据根据E-value升序，发现结果排序靠前的均为血红蛋白，与训练数据中含两个人血红蛋白相关

#本地数据的扩展探究

在使用`HMMER`前，先观察服务器上`/rd1/home/public/HMMER/`目录和`/rd1/home/public/hmmer-data/`目录下的文件，他们的格式以及内容：

* `15ATSBPD.aln`，比对结果文件，第一行有表示多序列比对结果的标识，后续是多个序列ID，序列以及用符号表示的结果：

  ```
  CLUSTAL 2.1 multiple sequence alignment
  
  
  SPL04A          RLCQVDRCTADMKEAKLYHRRHKVCEVHAKASSVFLSGLNQRFCQQCSRFHDLQEFDEAK
  SPL05A          RLCQVDRCTVNLTEAKQYYRRHRVCEVHAKASAATVAGVRQRFCQQCSRFHELPEFDEAK
  SPL03A          GVCQVESCTADMSKAKQYHKRHKVCQFHAKAPHVRISGLHQRFCQQCSRFHALSEFDEAK
  SPL01A          AVCQVENCEADLSKVKDYHRRHKVCEMHSKATSATVGGILQRFCQQCSRFHLLQEFDEGK
  SPL12A          ICCQVDNCGADLSKVKDYHRRHKVCEIHSKATTALVGGIMQRFCQQCSRFHVLEEFDEGK
  SPL14A          PMCQVDNCTEDLSHAKDYHRRHKVCEVHSKATKALVGKQMQRFCQQCSRFHLLSEFDEGK
  SPL08A          PRCQAEGCNADLSHAKHYHRRHKVCEFHSKASTVVAAGLSQRFCQQCSRFHLLSEFDNGK
  SPL06A          PLCQVYGCSKDLSSSKDYHKRHRVCEAHSKTSVVIVNGLEQRFCQQCSRFHFLSEFDDGK
  SPL13A          PICLVDGCDSDFSNCREYHKRHKVCDVHSKTPVVTINGHKQRFCQQCSRFHALEEFDEGK
  SPL09A          PRCQVEGCGMDLTNAKGYYSRHRVCGVHSKTPKVTVAGIEQRFCQQCSRFHQLPEFDLEK
  SPL15A          ARCQVEGCRMDLSNVKAYYSRHKVCCIHSKSSKVIVSGLHQRFCQQCSRFHQLSEFDLEK
  SPL10A          PRCQIDGCELDLSSSKDYHRKHRVCETHSKCPKVVVSGLERRFCQQCSRFHAVSEFDEKK
  SPL11A          PRCQIDGCELDLSSAKGYHRKHKVCEKHSKCPKVSVSGLERRFCQQCSRFHAVSEFDEKK
  SPL02A          PHCQVEGCNLDLSSAKDYHRKHRICENHSKFPKVVVSGVERRFCQQCSRFHCLSEFDEKK
  SPL07A          ARCQVPDCEADISELKGYHKRHRVCLRCATASFVVLDGENKRYCQQCGKFHLLPDFDEGK
                    *    *  ::.  : *: :*::*   :. . .      :*:****.:** : :**  *
  ```

* `15ATSBPD.FASTA`，序列文件，标准`fasta`格式，表示需要多序列比对的序列

* `15ATSBPD.hmm`，`HMMER`运行结果文件，含有`HMMER`版本，运行名称，长度，标识符，运行时间，序列数目

了解了这些文件的含义和内容，我们参照李帅同学的指导和官方的tutorial进行实验，首先构建索引：

```bash
hmmbuild ./15ATSBPD.hmm ./HMMER/15ATSBPD.aln
diff ./15ATSBPD.hmm ./HMMER/15ATSBPD.hmm
```

得到输出：

```bash
# hmmbuild :: profile HMM construction from multiple sequence alignments
# HMMER 3.1b2 (February 2015); http://hmmer.org/
# Copyright (C) 2015 Howard Hughes Medical Institute.
# Freely distributed under the GNU General Public License (GPLv3).
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# input alignment file:             ./HMMER/15ATSBPD.aln
# output HMM file:                  ./15ATSBPD.hmm
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# idx name                  nseq  alen  mlen eff_nseq re/pos description
#---- -------------------- ----- ----- ----- -------- ------ -----------
1     15ATSBPD                15    79    79     0.71  0.714

# CPU time: 0.09u 0.00s 00:00:00.09 Elapsed: 00:00:00.11
```

以及差异：

```
1c1
< HMMER3/f [3.1b2 | February 2015]
---
> HMMER3/f [3.3.2 | Nov 2020]
10c10
< DATE  Thu Mar 30 16:45:53 2023
---
> DATE  Sat Apr  9 22:04:10 2022
```

可见两者结果没有差异。

> 根据输出信息，我们可以得到如下的内容：
>
> * `nseq`，15条序列的比对结果
> * `alen`，长度均为79，且`mlen`，共有序列长度79
> * `eff_nseq`，有熊序列0.71，意味着有约11条序列相似，`re/pos`代表每个位置的相对熵值

根据`hmmbuild`的参数，我们可以知道其可以用于蛋白质、DNA、RNA同源序列的索引构建，可以通过更改策略、调整序列权重，先验频率参数等调整结果，**这一部分有待继续深入探索**

接下来我们用`hmmsearch`搜索序列数据库：

```bash
hmmsearch ./15ATSBPD.hmm uniprot_sprot.fasta > ./15ATSBPD.search.out
cat ./15ATSBPD.search.out | head
```

选取其中一栏作为参考分析：

```bash
# hmmsearch :: search profile(s) against a sequence database
# HMMER 3.1b2 (February 2015); http://hmmer.org/
# Copyright (C) 2015 Howard Hughes Medical Institute.
# Freely distributed under the GNU General Public License (GPLv3).
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# query HMM file:                  ./15ATSBPD.hmm
# target sequence database:        uniprot_sprot.fasta
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Query:       15ATSBPD  [M=79]
Scores for complete sequences (score includes all domains):
   --- full sequence ---   --- best 1 domain ---    -#dom-
    E-value  score  bias    E-value  score  bias    exp  N  Sequence              Description
    ------- ------ -----    ------- ------ -----   ---- --  --------              -----------
    1.1e-40  142.6  10.0    2.7e-40  141.4  10.0    1.7  1  sp|Q94JW8|SPL6_ARATH   Squamosa promoter-binding-like protein

Domain annotation for each sequence (and alignments):
>> sp|Q94JW8|SPL6_ARATH  Squamosa promoter-binding-like protein 6 OS=Arabidopsis thaliana OX=3702 GN=SPL6 PE=1 SV=2
   #    score  bias  c-Evalue  i-Evalue hmmfrom  hmm to    alifrom  ali to    envfrom  env to     acc
 ---   ------ ----- --------- --------- ------- -------    ------- -------    ------- -------    ----
   1 !  141.4  10.0   2.7e-44   2.7e-40       2      77 ..     123     198 ..     122     200 .. 0.98

  Alignments for each domain:
  == domain 1  score: 141.4 bits;  conditional E-value: 2.7e-44
              15ATSBPD   2 lCqvegCeadlseakdyhrrhkvCevhskaskvvvsgleqrfCqqCsrfhllsefdegkrsCrrrlaghnerrrkk 77
                           lCqv gC++dls++kdyh+rh+vCe+hsk+s+v+v+gleqrfCqqCsrfh lsefd+gkrsCrrrlaghnerrrk+
  sp|Q94JW8|SPL6_ARATH 123 LCQVYGCSKDLSSSKDYHKRHRVCEAHSKTSVVIVNGLEQRFCQQCSRFHFLSEFDDGKRSCRRRLAGHNERRRKP 198
                           8**************************************************************************8 PP
```

输出中单行的结果表示序列查询结果：

* 1-3列：按`E-value`从小到大排序，表示显著性更高，*E-value的大小依赖数据库的大小，大的数据库意味着更大的假阳性率*：`score`，完整序列的似然分数，`bias`，偏差，只有与`score`数量级接近时需要注意

* 4-6列描述得分最高的结构域，其值与前文的描述类似
* 7-8列：`exp`描述目标序列中结构域的期望数，结果中为1.7，而`N`则描述经过处理后最终决定鉴定到的结构域的数目为1

输出中多行的是每个序列的结构域注释，其中选择的为`SPL6_ARATH`序列，其中有1个结构域，从左至右依次表示：序号，是否满足每个序列和每个结构域的阈值（**什么意思**），`score`和`bias`，条件`E-value`，独立`E-value`，`hmm`在索引中的起始点，比对目标序列中的起始点，目标序列上定位的范围，平均后验概率

输出中后续的代码：表示比对共有序列的比对情况，字母代表匹配，`+`代表残基有正的`log-odds`发射分数，目标序列以及每个残基的后验概率

###未解决的问题    
1.插入氨基酸的评分矩阵每一行都是相同的，这取决于每种碱基在全局出现的概率，那为什么不统一储存全局出现的概率而是蛋白的每一位都储存相同的数值，这样不是比较浪费空间吗？
      
2.hmmbuild是如何处理比对结果的？当输入的序列长度不同时将如何计算profile的位数和各个位上的值?
