### LEB G03 第4次小组讨论报告

组长：易鼎程
执笔：朱亦文 易鼎程

### 时间

2023年4月8日晚19-21点 

### 方式

线下小组讨论

### 主题

- Vim 编辑器的使用
- Vimrc 配置与插件
- Neovim 与 VSCodeVim

### Vim 编辑器

Vim 编辑器（Vi IMproved）是一种高效的模式型编辑器，在不同模式下键盘上的按键具有不同的含义。大部分 UNIX 系统都内置了 vi 文书编辑器，vim (vi improved)由 vi 发展而来，功能更全面。

Vim 主要具有4种模式，它们分别是普通模式 (Normal mode, 又称命令模式)，插入模式 (Insert mode)、可视模式 (Visual mode)和底线命令模式（Last line mode）。还有一些相对少用的模式，如替换模式 (Replace mode)和终端模式 (Terminal Mode, 在 neovim 的内置终端中使用)

使用 vim+文件名打开文件时，默认进入命令模式，此时输入 i (或 a/o)可以进入插入模式，输入: 可以进入底线命令模式。在插入模式下，使用 esc 可以回到命令模式；底线命令模式下，使用 enter 键执行命令可以回到命令模式。输入: wq，文件被保存并退出。以上模式间关系如图所示:

![[Pasted image 20230409210923.png]]

#### 普通模式

Vim 的强大之处主要体现在它的普通模式中。在这个模式下，键盘上的许多字母键被赋予了特有的含义，可以使用它们来组成许多方便的编辑命令，快速地编辑文本。使用 Vim 的程序员们曾有一句口号叫做“Edit the text at the speed of thought”，生动形象的表现了 Vim 的强大之处。

普通模式下最主要的命令可以分成3大类，编辑类命令 (operator)，查找类命令 (find)和移动类命令 (motion)。列表总结如下：

| 命令                  | 描述                                       |
| --------------------- | ------------------------------------------ |
| 编辑类命令 (operator) |                                            |
| d                     | 删除 (Delete) 命令                         |
| c                     | 更改 (Change) 命令，即删除之后进入插入模式 |
| y                     | 复制 (Yank)命令                            |
| p                     | 粘贴 (Paste)命令                           |
| =                     | 自动格式化 (Format)文本                    |
| 查找类命令 (find)     |                                            |
| f                     | 在当前行向后查找字符 (Find)                |
| F                     | 向前查找字符 (Find backwards)              |
| /                     | 全局查找 (Find globally)                   |
| ?                     | 向前全局查找 (Find backwards globally)     |
| 移动类命令 (motion)   |                                            |
| $                     | 移动到行尾                                 |
| ^                     | 移动到行首第一个非空字符                   |
| 0                     | 移动到行首                                            |
| h                     | 向左移动一个字符                           |
| l                     | 向右移动一个字符                           |
| j                     | 向下移动一个字符                           |
| k                     | 向上移动一个字符                           |
| w                     | 向后移动一个单词                           |
| b                     | 向前移动一个单词                           |
| e                     | 向后移动到单词的末尾                       |
| ge                    | 向前移动到单词的末尾                       |
| gg                    | 移动到文件的第一行                         |
| G                     | 移动到文件的最后一行                       |

但是，只有这些命令还不能构成 Vim 的独特之处。Vim 的独特之处在于，它实现了一种特殊的语法，使得编辑命令能够组合使用。这个语法的基本模式是：

**{count}{operator}{motion}** 或 **{operator}{count}{motion}**

它的意思是，对 **{motion}** 指定的范围使用 **{operator}** ，总共使用 **{count}** 次。

下面举几个具体的例子来展示这一语法的作用。
1. d2w (delete two words) :
命令使用前：one **t**wo three four
命令使用后：one **f**our
2. d2j or 2dd (delete two lines)：删除两行
3. ggdG (move to first line, then delete to the end)：删除文件中所有内容

普通模式下，假如重复一个 **{operator}** 两次，或者按 shift + **{operator}**，那么默认这个操作是对目前光标所在行执行，如 dd 将会删除（剪切）这一行，而 yy 将会拷贝这一行。

普通模式下的其他命令，如 o, O, A 等，本质上都可以看做是这些基本命令的组合。

#### 插入模式

命令模式下按键 i (insert) /a (append) /o (open a new line) 将进入插入模式，插入模式下将同一般文本编辑器插入或回车删除修改文本。命令模式下按键 r 进入替换模式，输入字符替换已有字符而不是插入。插入模式下按键 esc 回到命令模式。

插入模式中，有一些命令让我们能够即时地修改输入的内容，这样我们无需退出到普通模式便可以进行常用的编辑操作。以下的命令中，\<C-a\>这样的记号表示 Ctrl+a 同时按下。这些命令包括：

| 命令              | 描述                           |
| ----------------- | ------------------------------ |
| \<C-h\>           | 删除前一个字符                 |
| \<C-w\>           | 删除前一个单词                 |
| \<C-u\>           | 删至行首                       |
| \<C-r\>{register} | 指定寄存器内的内容粘贴至光标处 |
| \<C-\[\>          | 退至正常模式                   |
| \<esc\>           | 退至正常模式                               |


#### 可视模式

在普通模式下键入 v，就进入了可视模式。可视模式下我们可以使用与普通模式中相同的移动命令进行光标的移动。与普通模式不同的是，可视模式下我们可以看到当前光标移动所建立的选区，并且可以对这个选区使用编辑命令进行编辑。可视模式对于初学使用 Vim 的新手来说很有帮助，因为在可视模式下命令的操作范围是可见而直观的。

#### 底线命令模式

在普通模式下输入 ': '，就进入了底线命令模式，在底线命令模式中我们可以运行一些对于文件操作的命令。

例如，输入: w，再按下回车，就可以保存文件；: q 退出 vim ；: wq 保存文件并退出。

较为常用的命令是替换命令（substitute），它的基本模式是:
:[range]s[ubstitute]/{pattern}/{string}/[flags]

在命令中，range 代表要替换的范围，可以使用行号或使用%指定全局范围。{pattern}是一处正则表达式，指定需要替换的文本。{string}表示要替换成为的字符串，而[flags]表示替换模式。其中用{}包裹的参数必须指定，而[]包裹的参数可以缺省。常用替换模式有 g, c 等，分别表示在一行中进行全局替换，和在每一个替换处提醒是否进行替换。

另一个常用的命令是帮助（help）。输入: h 并按下回车，我们就打开了 Vim 自带的帮助文档。输入: h 再按下 Tab 键，我们看到 Vim 会给我们自动补全出各种 Vim 中配置的帮助。

#### .vimrc 文件

Vim 的强大之处还在于它能够完全自主地定制。这种定制模式是通过. vimrc 文件配置实现的。. vimrc 文件是 vim 的配置文件，启动 vim 时会自动运行该配置，从而用户可以通过修改. vimrc 改变 vim 配置。. vimrc 的配置是使用一种特殊的脚本语言：vimscript 来表示的，具体的配置可以参考许多 github 上已有的配置。

在自己的 home 目录下，使用 vim .vimrc 创建配置文件，由于该文件为隐藏文件，需要用 ls -a 进行查看。

使用 set 关键字可以设定一些 vim 参数，如 set relativenumber 可以添加相对行号，便于定位文本位置进行跳行、翻页等。使用 map 可以进行快捷键设置，调整自己习惯的键位。set colorscheme=主题 (如 desert)可以改变颜色显示。

用户自定义的内容要想在 vim 中保持，就需要通过. vimrc 文件，因此安装 vim 插件等也都需要通过修改. vimrc 文件实现。

#### Vim 插件

vim 本身是高效的文本处理工具，为了使这种能力在脚本书写和 debug 等实际应用中发挥作用，仅仅修改. vimrc 文件较为繁琐，需要安装一些插件。同其他工具一样，安装插件需要插件管理器，较为常用的插件管理器为 Vim-Plug。执行以下命令以在 vim 文件夹下创建插件路径，事实上这是从 Github 下载 Vim-Plug 插件的过程。

![[Pasted image 20230409213043.png]]
![](file:///C:/Users/ydc2020/AppData/Local/Temp/msohtmlclip1/01/clip_image002.png)

安装完成后，在.vimrc中添加加载插件的命令:

```
call plug#begin('~/.vim/plugged')
# 中间放要安装的插件及配置
call plug#end()
```

将加载要安装的插件的命令置于两行之间，便可以使vim获得其功能。以vim which key为例: 由于vim有众多的快捷键，且允许用户自行设置快捷键，用户不能记忆快捷键时情况将变得较为复杂。Vim which key插件想要实现快捷键提示，使用户能够快速完成文本编辑。

首先在加载插件的命令中间添加Plug: Plug 'liuchengxu/vim-which-key'，随后根据插件对应的提示修改.vimrc，使得快捷键可被查询。修改完成后，重启vim，直接输入vim，在vim界面输入:PlugInstall完成插件安装。

值得提出的是，插件安装的过程中，会发现许多插件因连接问题难以从国内直接下载，可以通过科学上网或从 [Vim Awesome](https://vimawesome.com/) 寻找其他来源进行下载。

#### Neovim 以及其他软件中的 Vim 模式

Vim 这种模式化编辑的设计是编辑器历史上最成功的设计之一（另一个较成功的设计是 Emacs，事实上，它们分别被称为编辑器的神和神的编辑器）。这可以从几乎所有 Linux 发行版都内置 Vim，以及许多代码编辑器（例如 VSCode）和 IDE（例如 Idea, Pycharm 等）中都有 Vim 插件看出。下面简要介绍 Neovim，以及 VSCodeVim 插件。

Neovim 是一个新时代的 Vim，它最早由巴西程序员 Thiago de Arruda Padilha 开发。开发 Neovim 的原因很有意思：为了扩展和升级 Vim，使得它更加现代并支持许多新的语言特性。本来 Thiago 想在 Vim 的基础上开发，并在 Vim 项目的开源仓库上提交了他对 Vim 的重构。但是这一重构被 Vim 的作者 Bram Moolenaar 拒绝了。这是因为 Bram 认为对 Vim 这样一个成熟的大型项目进行这样规模的重构具有太大的风险。于是，Thiago 就发起了 Neovim 项目。Neovim 和 Vim 的主要区别在于它支持使用 Lua 语言对 Vim 进行配置，并且具有许多新特性，如异步 IO，浮动窗口，原生 LSP 支持，内置终端模拟器等。这些特性使得 Neovim 的开发大为火热，有许多开发者加入到 Neovim 的开发中，并产生了许多由开源社区维护的 Neovim 配置包，如 LunarVim, SpaceVim 和 LazyVim 等。

LazyVim 配置完成后效果图：

![[Pasted image 20230408231349.png]]

![[Pasted image 20230408231426.png]]

VSCodeVim 插件是当前最流行的编辑器 VSCode 中一个模拟 Vim 编辑模式的插件，可以通过插件市场安装。该插件提供了大多数 Vim 中的操作模式和命令，对于初学者来说是一个非常好的开始使用 Vim 的起点。但是，它并没有实现 Vim 的全部功能，如在 VSCodeVim 中无法使用宏（Macro）和表达式寄存器 (Expression Register)。

在 VSCode 中使用 Vim 效果图，注意最下方状态栏的--NORMAL--：
![[Pasted image 20230408231959.png]]


#### Vim 的学习

Vim 内置了一个简短的教程，只需要在 Bash shell 中输入 vimtutor，或在 Vim 中输入: tutor 命令，即可进入 Vim 教程。

另一个比较好的 Vim 教程是 VSCode 中的插件 LearnVim 所提供的，它讲述了大多数 Vim 的常用命令，以及一些由 Vim 插件实现的命令，如 Easymotion，Vim-surround 等。

另外也有许多有关 Vim 的书籍，例如《Vim 实用技巧》就是非常好的一本介绍如何使用 Vim 进行文本编辑的入门书。

Vim 的官方网站是 www.vim.org ，其中提供了许多有用的 Vim 插件资源和 Vim 的官方文档。

### 参考

www.runoob.com/linux/linux-vim.html

[Home - Neovim](http://neovim.io/)

[🚀 Getting Started | LazyVim](https://www.lazyvim.org/)

[welcome home : vim online](https://www.vim.org/)

[VSCodeVim/Vim: Vim for Visual Studio Code (github.com)](https://github.com/VSCodeVim/Vim)