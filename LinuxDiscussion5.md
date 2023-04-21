## LEB课程小组讨论总结报告

**组：G03	第5次讨论	组长：易鼎程**

时间：2023.4.16

方式：线下讨论

主题：Bash脚本讨论



**目录：**

[TOC]

`bash`脚本包含很多比较复杂的语法和逻辑，在编写`bash`脚本的时候，不仅要考虑变量之间的转换关系与字符串操作，还需要注意各类结构符号的使用，本次主要针对不同括号种类进行了讨论

### 关于括号的作用：

以下内容基于Bash版本`4.4.20(1)-release`

#### 小括号

`()`的作用，总结为**执行命令组**和**初始化数组**两种功能：

* 执行命令组：

  ```bash
  #!/bin/bash
  
  echo $( VAR="Hello!";echo $VAR )
  ```

  执行该命令完成了如下的任务：

  * 该bash由`/bin/bash`路径下的可执行文件`bash`解释，在执行`bash`时，先运行相应的`.bashrc`文件构建新的`bash`进程上下文

  * 相应在`echo ( ... )`中，小括号中的内容被作为命令组，传入该程序`fork`创建的子进程`bash`中，该子`bash`继承父进程的环境变量；创建子进程时，不会再调用`.bashrc`中的指令初始化，从而`.bashrc`中相关的`alias`设定没有效果，但会继承父进程的变量，而父进程不能访问子进程的变量，继续输入：

    ```bash
    echo $VAR
    ```

    会输出空

  * 使用`$`符号将执行子命令的`bash`标准输出的字符串序列拷贝到父`bash`中的变量

* 初始化数组

  不常用，但可以用于定义一些常量：

  ```bash
  #!/bin/bash
  
  samples=( SRR1059081 SRR1059082 SRR1059083 )
  
  for sample in samples; do
  	echo $sample
  done
  echo ${sample[2]}
  ```

  会一次输出三个样本号和第三个样本号，即支持通过数组下标访问

#### 双小括号

`(( ... ))`用于算数表达式，可以进行整数运算，在`(( ... ))`之中的语句会被解释为算数语言：

```bash
> i=0
> echo $i
0
> ((i+=2))
> echo $i
2
```

#### 中括号

方括号`[]`主要用于**条件测试**以及**数组取下标**

* 对于`[ ... ]`，等价于`test`命令的间歇，用于对条件表达式进行测试，可以跟在`if`，`while`和`for`后面，具体的格式此处省略，例如下：

  ```bash
  if [ -f myfile.txt ]; then
  	echo "File exists"
  fi
  ```

  是一个常见的检验文件是否存在的方法，其他的常见测试条件见下：

  | 符号 | 意义（ == True）                     |
  | ---- | ------------------------------------ |
  | -n   | 长度非0，或已定义                    |
  | -z   | 长度为0，或未定义                    |
  | =    | （对于字符串，全部）相等             |
  | !=   | （对于字符串，任一）不等             |
  | -eq  | （对于字符串，第一个字符）相等       |
  | -ef  | 设备号与节点号相同                   |
  | -f   | 存在且是正规文件（非符号连接、目录） |
  | -e   | 存在                                 |
  | -d   | 存在且是目录                         |
  | -h   | 存在且是符号链接                     |
  | -r   | 存在且可读                           |
  | -w   | 存在且可写                           |
  | -x   | 存在且可执行                         |
  | -a   | 表达式都为真                         |
  | -o   | 表达式有一个为真                     |

  *相关的整数比较大小，如`-gt`，`-le`等，由于较为简单不在列举，部分不常用不列出*

* 对于`[[ ... ]]`，其属于`bash`中对于`shell`本身`test`指令所不能满足的条件的扩展，提供了更多功能，比如模式匹配和正则表达式：

  ```bash
  if [[ $VAR == *"World"* ]]; then
  	echo "Contains World"
  fi
  ```

#### 大括号

大括号`{}`主要用于**命令组**和**变量替换**

* 在作为命令组时，与`()`代表的命令组不同的是，大括号会在当前的`bash`进程中执行，而不会`fork`子`bash`，这对于变量赋值和修改当前环境变量有用：

  ```bash
  #!/bin/bash
  
  { VAR="Hello!";echo $VAR } > var.out
  ```

  同时，可以对命令组中的指令进行相同的操作，例如将他们的标准输出一同重定向到其他文件中

* 变量替换，即使用`${ ... }`的形式对变量字符串进行相关操作，或者用于划分变量名称的界限，一些相关的操作可以总结如下：

  定义变量`file=/dir1/dir2/dir3/my.file.txt`，我们可以用 `${ } `分别替换获得不同的值：

  * `${#file}`：表示变量长度

  使用取子串操作：

  * `${file#*/}`：拿掉第一条` / `及其左边的字符串：`dir1/dir2/dir3/my.file.txt`
  * `${file##*/}`：拿掉最后一条` / `及其左边的字符串：`my.file.txt`
  * `${file#*.}`：拿掉第一个 `. `及其左边的字符串：`file.txt`
  * `${file##*.}`：拿掉最后一个` . `及其左边的字符串：`txt`
  * `${file%/*}`：拿掉最后条 `/ `及其右边的字符串：`/dir1/dir2/dir3`
  * `${file%%/*}`：拿掉第一条` / `及其右边的字符串：(空值)
  * `${file%.*}`：拿掉最后一个` . `及其右边的字符串：`/dir1/dir2/dir3/my.file`
  * `${file%%.*}`：拿掉第一个` . `及其右边的字符串：`/dir1/dir2/dir3/my`

  总结为`%`为去掉右边，`#`为去掉右边，单一符号是最小匹配，两个符号是最大匹配

  同时也可以使用模式匹配：

  * `${file:0:5}`：最左边的五个字节：`/dir1`
  * `${file:5:5}`：第五个字节右边连续的5个字节：`/dir2`

  我们也可以对变量值里的字符串作替换：

  * `${file/dir/path}`：将第一个 `dir `提换为` path`：`/path1/dir2/dir3/my.file.txt`

  * `${file//dir/path}`：将全部 `dir` 提换为`path`：`/path1/path2/path3/my.file.txt`

  利用 `${}`还可针对不同的变量状态赋值(没设定、空值、非空值)： 

  * `${file-my.file.txt} ` ：假如 `$file`没有设定，则使用 `my.file.txt` 作传回值

  * `${file:-my.file.txt}` ：假如 `$file` 没有设定或为空值，则使用 `my.file.txt` 作传回值

  * `${file+my.file.txt}` ：假如 `$file` 设为空值或非空值，均使用 `my.file.txt` 作传回值

  * `${file:+my.file.txt}` ：若 `$file` 为非空值，则使用 `my.file.txt` 作传回值
  * `${file=my.file.txt}` ：若 `$file` 没设定，则使用 `my.file.txt` 作传回值，同时将`$file`赋值为 `my.file.txt`

  * `${file:=my.file.txt}` ：若 `$file` 没设定或为空值，则使用 `my.file.txt` 作传回值，同时将 `$file` 赋值为 `my.file.txt` 
  * `${file?my.file.txt}` ：若 `$file` 没设定，则将 `my.file.txt` 输出至标准错误输出

  * `${file:?my.file.txt}` ：若 `$file` 没设定或为空值，则将 my.file.txt 输出至标准错误输出

  除此之外，我们还发现这样的用法：

  * `${!file}`：会将`file`变量作为变量名，再返回该变量名的内容，即为间接引用

#### 补充

* 除以上`()`，`[]`与`{}`的功能外，还有一些使用方法，可以与命令结合进行理解，常见于命令`specific`的语法中，例如`find`指令：

  ```bash
  find . -name "*.txt" -exec cp {} /tmp \;
  ```

  可以认为`{}`是`find`指令为标准输出结果定义的占位符

* `[]`与`(())`的有些用法相同，可以用于算数运算，当前方用`$`进行访问时

### 关于bash的环境变量

`bash`脚本本身包括一些预定义的环境变量，可以在运行中访问获得相关的`bash`信息，除`$BASH`打印`bash`可执行文件路径与`$BASH_VERSION`打印`bash`版本外，还有以下常用的环境变量

> 此处补充`export`的作用：
>
> `export`命令用于将变量输出为环境变量，或者将函数输出为环境变量，子进程可以通过`export`将变量“广播”给父进程，但同时其他程序也会知晓

#### 运行时特殊变量，由`bash`进程控制，用户无法改变地变量

* `$i`，上一次执行命令的退出码

  ```bash
  > ls ./
  test.sh
  > echo $?
  0
  > ls noexists
  ls: cannot access noexists: No such file or directory
  > echo $?
  2
  ```

* `$$`，当前`shell`进程`ID`

* `$_`，上一个命令的最后一个参数

* `$!`，最后一个后台异步执行的命令的进程`PID`

* `$0`，当前`shell`名称

* `$@,$#,$N`，表示`bash`进程装载时参数的数量、值和第N个参数

> 在`bash`中可以使用`readonly`指令来声明只读变量，用`declare`指令来声明可读可写变量，将普通变量改为特殊变量

#### 系统预设变量，由`bash`预设的环境变量

* `$BASH`，`$BASH_VERSION`

* `$EUID`，当前使用交互式`shell`的用户
* `$HISCMD`，当前指令的序号，在`history`中的
* `$PWD`，当前目录
* `$PATH`，`bash`命令的搜索路径
* `$BASHPID`，当前的`bash`进程`PID`
* `$BASH_SUBSHELL`，记录了一个`bash`进程实例中多个`subbash`嵌套深度的累加器
* `$SHLVL`，记录了多个`bash`进程实例嵌套深度的累加器

例如：

```bash
#!/bin/bash
 
task1() {
	# do something...
}
 
task2() {
	# do something...
}
 
task3() {
	# do something...
}
 
# define some other tasks...
 
# use & if we want to implement multiprocess
# (task1 &)
(task1)
(task2)
(task3)
# run some other tasks...
 
# run commands from command line arguments
for cmd in "$@"; do
  ($cmd)
done
```

