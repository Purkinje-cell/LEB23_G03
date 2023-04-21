### Leb03组第一次讨论总结报告

[TOC]

**组：leb23G03**

**第一次**

**组长：易鼎程**

**执笔：王沛宇**

#### 时间

2023.3.6晚，7:00-9:00

#### 方式

线下讨论

#### 主题

* EMBOSS软件包的使用
* Linux服务器常用命令

#### 内容

1. 如何打开`svg`文件
   * 第一种方法，需要将`svg`文件传输到本地
     * 可以使用的指令有`sftp`，`scp`，软件有`vscode`的`ssh-remote`插件，`filezilla`，`mobaxterm`自带的浏览器
   * 第二种方法，直接在服务端打开
     * `vscode`自带`open with explorer`或`view svg`插件
     * 使用`mobaxterm`直接输出`x11`格式的文件即可打开，再截图保存即可

2. 如何从`genbank / uniprot`下载数据
   * 如果数据量比较小，或是特定需要的序列（管家、参考基因、蛋白）等，可以直接从网站上手动下载
   * 如果数据量比较大，可以从通过`ftp`协议下载，用`wget -c`或用`ftp`协议下载

3. `EMBOSS`中的不同`dot`功能的区别：

   * `dottup`：一个word要在两个序列里面完全一模一样才有`dot`，即基于相同位点，可以做蛋白核核酸

   * `dotmatcher`：不完全匹配，但是只要在`threshold`以上，就有`dot`，即基于罚分矩阵，只能做蛋白

   * `dotpath`：只显示主对角线相对应的区域

   * `polydot`：生成一个对于所有序列的相似度文件，两两产生

     <img src="C:\Users\10713\AppData\Roaming\Typora\typora-user-images\image-20230306210122423.png" alt="image-20230306210122423" style="zoom:50%;" />

4. 讨论`EMBOSS`软件包`dottup`和`dotmatcher`产生绘图错误的原因：

   我们观察了`EMBOSS`软件包，位于集群`/rd1/home/public/EMBOSS-6.6.0.tar.gz`的安装包，其中`emboss/dottup.c`文件包含代码行：

   ```c
   # dottup.c
   # line 99
   	seq1    = ajAcdGetSeq("bsequence");
       seq2    = ajAcdGetSeq("asequence");
   
   # line 352
       ajGraphSetYlabelC(graph,ajSeqGetNameC(seq1));
       ajGraphSetXlabelC(graph,ajSeqGetNameC(seq2));
   ```

   出现了`ajAcdGetSeq`函数的参数填写`bsequence`和`asequence`顺序错误，推测是造成图片`x`轴和`y`轴颠倒的原因；只需要调换即可获得正确结果；测试数据`HBA_HUMAN`和`HBB_HUMAN`

   修改之前：

   <img src="C:\Users\10713\AppData\Roaming\Typora\typora-user-images\image-20230306201804433.png" alt="image-20230306201804433" style="zoom:33%;" />

   修改之后：

   <img src="C:\Users\10713\AppData\Roaming\Typora\typora-user-images\image-20230306203300390.png" alt="image-20230306203300390" style="zoom:33%;" />

   我们的组长同学尝试了`conda`上的`emboss-6.5.7`，相应的输出结果与错误图一致；

#### 问题

* 【未解决】`dottup`如何修改输出的`svg`文件的图片`title`

