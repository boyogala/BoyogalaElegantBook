% -----------------------------------------------------------------------------
% Start of file `boyogalaelegantbook.cls'.
% Copyright 2013-2022 ElegantLaTeX (elegantlatex2e@gmail.com)
% Copyright 2026-     BoyogalaElegantBook (boyogala@qq.com)
% This work may be distributed and/or modified under the conditions of the LaTeX Project Public License,
% either version 1.3c of this license or (at your option) any later version.
%
% Based on ElegantBook, see https://github.com/ElegantLaTeX/ElegantBook
% This project:   https://github.com/boyogala/BoyogalaElegantBook
%
% BoyogalaElegantBook: single font configuration, XeLaTeX only.
% All text and maths fonts are read from ./fonts and are licensed under the
% SIL Open Font License 1.1 (see fonts/OFL.txt).
% -----------------------------------------------------------------------------
% ============================================================================
% BoyogalaElegantBook —— 面向中文书籍排版的 LaTeX 文类
%
% 设计目标：
%   1. 只有一种字体配置：西文、中文与数学字体全部随项目提供，位于 ./fonts
%      目录，均为 SIL Open Font License 1.1，排版结果与系统字体无关；
%   2. 只支持 XeLaTeX：字体统一由 fontspec 与 unicode-math 加载；
%   3. 依赖精简：非必要的宏包一律不加载，确实需要时在文档中按需 \usepackage；
%   4. 保留 ElegantBook 的核心版式：封面、定理环境、目录、修订历史、旁注等。
%
% 主要功能：
%   · 封面：标题、副标题、作者、机构、日期、版本、箴言、封面图与徽标均可选；
%   · 定理环境：fancy（tcolorbox 彩色框）与 simple（amsthm 原生）两种模式，
%     支持自定义定理环境、多个环境共享计数器、按章或按节编号；
%   · 示例环境：example、exercise、problem、note、solution、remark 等；
%   · 目录：单栏或双栏，章标题可显示为“第 N 章”或“第一章”；
%   · 修订历史：\datechange 命令 + change 环境 + \listofchanges；
%   · 配色：5 套预设主题，或用 color=none 自行定义。
%
% 许可证：LPPL 1.3c（见 LICENSE 文件）；字体为 OFL 1.1（见 fonts/OFL.txt）。
% ============================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{boyogalaelegantbook}[2026/05/01 v4.7 BoyogalaElegantBook document class]

%%%
% ============================================================================
% 一、选项系统
% ============================================================================
% 使用 kvoptions 宏包定义类选项，全部选项归入 BOYOGALA 族，
% 类文件内部通过 \ekv{<key>=<value>} 设置选项。
%
% 带值选项（key=value 形式）：
%   lang       语言：cn 简体中文、cht 繁体中文、en 英文（默认 en）
%   color      配色：green / cyan / blue（默认）/ gray / black / none
%   mode       定理环境样式：fancy（默认，彩色框）/ simple（amsthm 原生）
%   device     版面：normal（A4，默认）/ pad（7.5x10 英寸，平板阅读）
%   toc        目录：onecol（默认）/ twocol（双栏）
%   titlestyle 章标题样式：hang（单行，默认）/ display（双行）
%   scheme     编号方案：chinese（章号显示为“第一章”）
%   thmcnt     定理计数器：chapter（默认）/ section
%   bibend     参考文献后端：biber（默认）/ bibtex
%   citestyle  引用样式，默认 numeric-comp
%   bibstyle   参考文献样式，默认 numeric
%   marginpar  边注：margintrue（开启右侧边注区）/ marginfalse（默认）
%
% 无值选项（历史兼容写法，与上面的带值选项等价）：
%   cn / cht / en                     语言
%   green / cyan / blue / gray / black / nocolor   配色
%   fancy / simple                    定理环境样式
%   normal / pad                      版面
%   onecol / twocol                   目录
%   hang / display                    章标题样式
%   chinese                           编号方案
%   chapter / section                 定理计数器
%   biber / bibtex                    参考文献后端
%   margintrue / marginfalse          边注
%   usesamecnt                        所有定理环境共用一个计数器
%
% 未被识别的选项转交给 book 类处理，因此 book 类的选项同样有效。
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=BOYOGALA, prefix=BOYOGALA@, setkeys=\kvsetkeys}
\newcommand{\ekv}[1]{\kvsetkeys{BOYOGALA}{#1}}
% ----- Colors -----
\DeclareStringOption[blue]{color}
\DeclareStringOption[en]{lang}
\DeclareStringOption[answer]{result}
\DeclareStringOption[fancy]{mode}
\DeclareStringOption[normal]{device}
\DeclareStringOption[marginfalse]{marginpar}
\DeclareStringOption[onecol]{toc}
\DeclareStringOption{scheme}

% ----- backward compatibility
\DeclareVoidOption{green}{\ekv{color=green}}
\DeclareVoidOption{cyan}{\ekv{color=cyan}}
\DeclareVoidOption{blue}{\ekv{color=blue}}
\DeclareVoidOption{gray}{\ekv{color=gray}}
\DeclareVoidOption{black}{\ekv{color=black}}
\DeclareVoidOption{nocolor}{\ekv{color=none}}

\DeclareVoidOption{chinese}{\ekv{scheme=chinese}}


\DeclareVoidOption{en}{\ekv{lang=en}}
\DeclareVoidOption{cn}{\ekv{lang=cn}}
\DeclareVoidOption{cht}{\ekv{lang=cht}}

\DeclareVoidOption{fancy}{\ekv{mode=fancy}}
\DeclareVoidOption{simple}{\ekv{mode=simple}}
\DeclareBoolOption[false]{usesamecnt}

\DeclareVoidOption{answer}{\ekv{result=answer}}
\DeclareVoidOption{noanswer}{\ekv{result=noanswer}}

\DeclareVoidOption{normal}{\ekv{device=normal}}
\DeclareVoidOption{pad}{\ekv{device=pad}}

\DeclareStringOption[numeric-comp]{citestyle}
\DeclareStringOption[numeric]{bibstyle}


\DeclareVoidOption{margintrue}{\ekv{marginpar=margintrue}}
\DeclareVoidOption{marginfalse}{\ekv{marginpar=marginfalse}}


\DeclareVoidOption{onecol}{\ekv{toc=onecol}}
\DeclareVoidOption{twocol}{\ekv{toc=twocol}}

\DeclareStringOption[chapter]{thmcnt}
\DeclareVoidOption{chapter}{\ekv{thmcnt=chapter}}
\DeclareVoidOption{section}{\ekv{thmcnt=section}}

\DeclareStringOption[biber]{bibend}
\DeclareVoidOption{biber}{\ekv{bibend=biber}}
\DeclareVoidOption{bibtex}{\ekv{bibend=bibtex}}


% ----- Math option -----
\newcommand\mailto[1]{\href{mailto:#1}{\nolinkurl{#1}}}

% 章标题样式：hang 单行显示（默认），display 双行显示。
% \style 供 titlesec 的 \titleformat 使用。
% ----- Title Style -----
\DeclareStringOption[hang]{titlestyle}[hang]
% ----- backward compatibility
\DeclareVoidOption{hang}{\ekv{titlestyle=hang}}
\DeclareVoidOption{display}{\ekv{titlestyle=display}}
% ----- Default Options -----
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{book}}

% 处理类选项：先读取键值选项，再把未知选项交给 book 类。
\ProcessKeyvalOptions*\relax
% \ProcessOptions*\relax
% ============================================================================
% 二、基类与页面
% ============================================================================
% 基于 book 类，固定单面排版（oneside）。纸张由 device 选项决定，
% 因此 book 类自带的纸张选项（如 a4paper）在此不起作用。
\LoadClass[a4paper,oneside]{book}

% 行距：中文正文行距为 1.3 倍，西文为 1.2 倍（见后文语言分支）。
\RequirePackage{setspace}



% ============================================================================
% 三、超链接
% ============================================================================
% 链接、引用与网址统一使用酒红色 winered；目录条目可直接点击跳转。
\RequirePackage{hyperref}
\hypersetup{
  breaklinks,
  unicode,
  linktoc=all,
  bookmarksnumbered=true,
  bookmarksopen=true,
  pdfkeywords={BoyogalaElegantBook},
  colorlinks,
  linkcolor=winered,
  citecolor=winered,
  urlcolor=winered,
  plainpages=false,
  pdfstartview=FitH,
  pdfborder={0 0 0},
  linktocpage
}
\newif\ifBOYOGALA@Hy@later
  \@ifpackagelater{hyperref}{2022/05/16}
    {\BOYOGALA@Hy@latertrue}
    {\BOYOGALA@Hy@laterfalse}

%% device settings
% 版面设置：
%   device=normal  A4 纸，页边距 20mm；开启 marginpar 时右侧留出 5cm 边注区。
%   device=pad     7.5x10 英寸的平板尺寸，页边距 16mm，适合手持阅读。
\RequirePackage{geometry}
\ifdefstring{\BOYOGALA@device}{normal}{
  \geometry{
    a4paper,
    top=25.4mm, bottom=25.4mm,
    left=20mm, right=20mm,
    headheight=2.17cm,
    headsep=4mm,
    footskip=12mm
  }
  \ifdefstring{\BOYOGALA@marginpar}{margintrue}{
    \geometry{
      marginparwidth=5cm, marginparsep=5mm,
      left=2cm,right=7cm}}{\relax}}{
    \relax}

\ifdefstring{\BOYOGALA@device}{pad}{
\geometry{
  paperwidth=7.5in, 
  paperheight=10in,
  margin=16mm,
  headheight=2.17cm,
  footskip=4mm
}}{\relax}


% indentfirst 让中文段落首行缩进；comment 提供 \excludecomment，
% 供 result=noanswer 选项隐藏“解”与“证明”环境。
\RequirePackage{indentfirst,comment}

\setcounter{tocdepth}{1}
\renewcommand{\baselinestretch}{1.2}

\RequirePackage{iftex}

% ============================================================================
% 四、字体（唯一配置）
% ============================================================================
% 全部字体从 ./fonts 目录读取，因此必须在包含 fonts/ 目录的项目根目录下编译。
%   西文正体    STIX Two Text
%   西文无衬线  Source Sans 3
%   等宽字体    JetBrains Mono
%   数学字体    STIX Two Math（经 unicode-math 加载）
%   中文宋体    思源宋体 Source Han Serif SC
%   中文黑体    思源黑体 Source Han Sans SC
%   中文楷体    霞鹜文楷 LXGW WenKai
%   中文仿宋    朱雀仿宋 Zhuque Fangsong
% 如需更换字体路径，可修改 \renewcommand{\BOYOGALA@fontpath}{...}。
% ----- Fonts: XeLaTeX only; every font is read from ./fonts (SIL OFL 1.1) -----
\ifxetex\else
  \ClassError{boyogalaelegantbook}{This class requires XeLaTeX}{Compile with xelatex or latexmk -xelatex.}
\fi
\newcommand{\BOYOGALA@fontpath}{./fonts/}
\RequirePackage[no-math]{fontspec}
\setmainfont{STIXTwoText-Regular.otf}[
  Path=\BOYOGALA@fontpath,
  BoldFont=STIXTwoText-Bold.otf,
  ItalicFont=STIXTwoText-Italic.otf,
  BoldItalicFont=STIXTwoText-BoldItalic.otf,
  Ligatures=TeX]
\setsansfont{SourceSans3-Regular.otf}[
  Path=\BOYOGALA@fontpath,
  BoldFont=SourceSans3-Bold.otf,
  ItalicFont=SourceSans3-It.otf,
  BoldItalicFont=SourceSans3-BoldIt.otf,
  Ligatures=TeX]
\setmonofont{JetBrainsMono-Regular.ttf}[
  Path=\BOYOGALA@fontpath,
  BoldFont=JetBrainsMono-Bold.ttf,
  ItalicFont=JetBrainsMono-Italic.ttf,
  BoldItalicFont=JetBrainsMono-BoldItalic.ttf,
  Scale=MatchLowercase]

% ---------- 语言判定开关 ----------
% 简体中文与繁体中文在排版结构上完全一致，故用同一个开关统一处理。
\newif\ifBOYOGALA@zh
\ifdefstring{\BOYOGALA@lang}{en}{\BOYOGALA@zhfalse}{\BOYOGALA@zhtrue}

% 中文字体的四种角色，与传统书籍的排版习惯一致：
%   宋体  正文
%   黑体  粗体与标题
%   楷体  定理类环境正文、斜体
%   仿宋  证明环境正文
% 由此提供 \songti、\heiti、\kaishu、\fangsong 四个命令。
% CJK fonts: 宋 body, 黑 bold/headings, 楷 italic/theorem bodies, 仿宋 proofs.
% Used by the Chinese and the Japanese mode; the user may replace them in the
% preamble with \setCJKmainfont and friends.
\newcommand{\BOYOGALA@cjkfonts}{%
  \setCJKmainfont[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf, ItalicFont=LXGWWenKai-Regular.ttf]{SourceHanSerifSC-Regular.otf}
  \setCJKsansfont[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf]{SourceHanSansSC-Regular.otf}
  \setCJKmonofont[Path=\BOYOGALA@fontpath]{SourceHanSansSC-Regular.otf}
  \setCJKfamilyfont{zhsong}[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf]{SourceHanSerifSC-Regular.otf}
  \setCJKfamilyfont{zhhei}[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf]{SourceHanSansSC-Regular.otf}
  \setCJKfamilyfont{zhkai}[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf]{LXGWWenKai-Regular.ttf}
  \setCJKfamilyfont{zhfs}[Path=\BOYOGALA@fontpath, BoldFont=SourceHanSansSC-Bold.otf]{ZhuqueFangsong-Regular.ttf}
  \newcommand*{\songti}{\CJKfamily{zhsong}}
  \newcommand*{\heiti}{\CJKfamily{zhhei}}
  \newcommand*{\kaishu}{\CJKfamily{zhkai}}
  \newcommand*{\fangsong}{\CJKfamily{zhfs}}
}

\ifdefstring{\BOYOGALA@lang}{cn}{
  \RequirePackage[UTF8, scheme=plain, fontset=none]{ctex}
  \BOYOGALA@cjkfonts

  \AfterEndPreamble{
    \setlength\parindent{2\ccwd}}
}{\relax}

% 繁体中文使用同一套字体
\ifdefstring{\BOYOGALA@lang}{cht}{
  \RequirePackage[UTF8, scheme=plain, fontset=none]{ctex}
  \BOYOGALA@cjkfonts

  \AfterEndPreamble{
    \setlength\parindent{2\ccwd}}
}{\relax}

\ifcsname heiti\endcsname
  \newcommand{\cbfseries}{\heiti}
\else
  \newcommand{\cbfseries}{\bfseries}
\fi


\ifcsname kaishu\endcsname
  \newcommand{\citshape}{\kaishu}
\else
  \newcommand{\citshape}{\itshape}
\fi
\ifcsname kaishu\endcsname
  \newcommand{\cnormal}{\kaishu}
\else
  \newcommand{\cnormal}{\normalfont}
\fi

\ifcsname fangsong\endcsname
  \newcommand{\cfs}{\fangsong}
\else
  \newcommand{\cfs}{\normalfont}
\fi


% ============================================================================
% 五、配色
% ============================================================================
% 四个语义色：
%   structurecolor  结构色：章标题、节标题、页眉横线
%   main            定义、练习、问题
%   second          定理、引理、推论、公理、公设、注记
%   third           命题、假设、结论、性质
% color=none 时给出占位定义，用户可在导言区用 \definecolor 重新定义。
% ----- Handle Colors -----
%% 章节以及页脚图形

\RequirePackage[table]{xcolor}
\ifdefstring{\BOYOGALA@color}{green}{
  \definecolor{structurecolor}{RGB}{0,120,2}%
  \definecolor{main}{RGB}{0,120,2}%
  \definecolor{second}{RGB}{230,90,7}%
  \definecolor{third}{RGB}{0,160,152}%
}{\relax}
\ifdefstring{\BOYOGALA@color}{cyan}{
  \definecolor{structurecolor}{RGB}{31,186,190}%
  \definecolor{main}{RGB}{59,180,5}%
  \definecolor{second}{RGB}{175,153,8}%
  \definecolor{third}{RGB}{244,105,102}%
}{\relax}
\ifdefstring{\BOYOGALA@color}{blue}{
  \definecolor{structurecolor}{RGB}{60,113,183}
  \definecolor{main}{RGB}{0,166,82}%
  \definecolor{second}{RGB}{255,134,24}%
  \definecolor{third}{RGB}{0,174,247}%
}{\relax}
\ifdefstring{\BOYOGALA@color}{gray}{
  \definecolor{structurecolor}{RGB}{150,150,150}
  \definecolor{main}{RGB}{150,150,150}%
  \definecolor{second}{RGB}{150,150,150}%
  \definecolor{third}{RGB}{150,150,150}%
}{\relax}
\ifdefstring{\BOYOGALA@color}{black}{
  \definecolor{structurecolor}{RGB}{0,0,0}
  \definecolor{main}{RGB}{0,0,0}%
  \definecolor{second}{RGB}{0,0,0}%
  \definecolor{third}{RGB}{0,0,0}%
}{\relax}
% With the "none" theme the user defines the colours in the preamble.  These
% placeholders only make sure that the class itself can be loaded.
\ifdefstring{\BOYOGALA@color}{none}{
  \definecolor{structurecolor}{RGB}{0,0,0}
  \definecolor{main}{RGB}{0,0,0}%
  \definecolor{second}{RGB}{0,0,0}%
  \definecolor{third}{RGB}{0,0,0}%
}{\relax}

%green color
\definecolor{structure1}{RGB}{0,120,2}%
\definecolor{main1}{RGB}{0,120,2}%
\definecolor{second1}{RGB}{230,90,7}%
\definecolor{third1}{RGB}{0,160,152}%
%cyan color
\definecolor{structure2}{RGB}{31,186,190}%
\definecolor{main2}{RGB}{59,180,5}%
\definecolor{second2}{RGB}{175,153,8}%
\definecolor{third2}{RGB}{244,105,102}%
%blue color
\definecolor{structure3}{RGB}{60,113,183}
\definecolor{main3}{RGB}{0,166,82}%
\definecolor{second3}{RGB}{255,134,24}%
\definecolor{third3}{RGB}{0,174,247}%
% gray color
\definecolor{structure4}{RGB}{150,150,150}
\definecolor{main4}{RGB}{150,150,150}%
\definecolor{second4}{RGB}{150,150,150}%
\definecolor{third4}{RGB}{150,150,150}%
% black color
\definecolor{structure5}{RGB}{0,0,0}
\definecolor{main5}{RGB}{0,0,0}%
\definecolor{second5}{RGB}{0,0,0}%
\definecolor{third5}{RGB}{0,0,0}%

% corlor definition
\definecolor{winered}{rgb}{0.5,0,0}
\definecolor{bule}{RGB}{18,29,57}
% The colour of the bar on the cover page; the user may redefine it in the
% preamble with \colorlet{coverlinecolor}{<colour>}.
\ifdefstring{\BOYOGALA@color}{none}{
  \definecolor{coverlinecolor}{RGB}{0,0,0}
}{
  \colorlet{coverlinecolor}{second}
}


% ----- Title Style -----
\ifdefstring{\BOYOGALA@titlestyle}{hang}{\def\style{hang}}{\relax}
\ifdefstring{\BOYOGALA@titlestyle}{display}{\def\style{display}}{\relax}
\ifx\style\@undefined\def\style{hang}\fi

% reference: 
% https://tex.stackexchange.com/questions/58506/how-to-make-a-new-command-similar-to-author
% https://pastebin.com/C8W4axzV
\newcommand\email[1]{\href{mailto:#1}{\nolinkurl{#1}}}

% ============================================================================
% 六、封面元信息
% ============================================================================
% \title、\subtitle、\author、\institute、\date、\version、\bioinfo、
% \extrainfo、\logo、\cover 均为可选：没有定义的内容不会出现在封面上。
\global\let\@title\@empty
\global\let\@author\@empty
\global\let\@date\@empty
\newcommand{\subtitle}[1]{\gdef\@subtitle{#1}}
\newcommand{\institute}[1]{\gdef\@institute{#1}}
\newcommand{\version}[1]{\gdef\@version{#1}}
\newcommand{\extrainfo}[1]{\gdef\@extrainfo{#1}}

\newcommand{\logo}[1]{\gdef\@logo{#1}}
\newcommand{\cover}[1]{\gdef\@cover{#1}}

\newcommand{\question}[1]{{\par\citshape #1}\\[0.2ex]}

% 列表与图表标题：enumitem 统一列表的间距与编号格式；
% caption 统一图表标题的字体与颜色。
% list/itemize/enumerate setting
\RequirePackage[shortlabels,inline]{enumitem}
\setlist{nolistsep}

\RequirePackage[labelfont={bf,color=structurecolor}]{caption} 
\captionsetup[table]{skip=3pt}
\captionsetup[figure]{skip=3pt}

\AtBeginDocument{
  \setlength{\abovedisplayskip}{3pt}
  \setlength{\belowdisplayskip}{3pt}
  \RequirePackage[flushmargin,stable]{footmisc}
  \setlength{\footnotesep}{12pt}
}


% 图形与数学：graphicx 负责插图，amsmath 提供数学环境，
% unicode-math 负责 STIX Two Math 数学字体。
\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{unicode-math}
\setmathfont{STIXTwoMath-Regular.otf}[Path=\BOYOGALA@fontpath]
% The bm package is not compatible with unicode-math; \symbf gives the same bold
% maths, and \bm is kept as a compatibility alias.
\providecommand{\bm}[1]{\symbf{#1}}
% \providecommand\qed{}
% \renewcommand{\qed}{\hfill\ensuremath{\square}}
\RequirePackage{booktabs}
\RequirePackage{multicol}

%%中文结构名字


%%   章节设置
\RequirePackage[center]{titlesec}
\RequirePackage[title,titletoc,header]{appendix}


% ============================================================================
% 十二、参考文献
% ============================================================================
% biblatex 生成参考文献，后端由 bibend 选项决定（biber 或 bibtex）；
% 引用样式与参考文献样式分别由 citestyle、bibstyle 两个选项控制。
\RequirePackage[
  backend=\BOYOGALA@bibend,
  citestyle=\BOYOGALA@citestyle,
  bibstyle=\BOYOGALA@bibstyle]{biblatex}

% Localisation strings: some of them are already defined by book or ctex,
% some of them are not defined at all.  \BOYOGALA@defname defines the macro
% when it does not exist yet and redefines it otherwise.
\newcommand{\BOYOGALA@defname}[2]{%
  \ifcsname #1\endcsname
    \expandafter\renewcommand\csname #1\endcsname{#2}%
  \else
    \expandafter\newcommand\csname #1\endcsname{#2}%
  \fi}

\ifdefstring{\BOYOGALA@lang}{cn}{
  \renewcommand{\baselinestretch}{1.3}
  \BOYOGALA@defname{contentsname}{目录}
  \BOYOGALA@defname{figurename}{图}
  \BOYOGALA@defname{tablename}{表}
  \BOYOGALA@defname{partname}{\color{structurecolor}}
  \renewcommand{\thepart}{第\zhnumber{\arabic{part}}部分}
  \BOYOGALA@defname{listfigurename}{插图目录}
  \BOYOGALA@defname{listtablename}{表格目录}
  \BOYOGALA@defname{bibname}{参考文献}
  \BOYOGALA@defname{ebibname}{参考文献}
  \BOYOGALA@defname{appendixname}{附录}
  \BOYOGALA@defname{appendixtocname}{附录}
  \BOYOGALA@defname{indexname}{索\hspace{2em}引}
  \newcommand\figref[1]{\textbf{图}~\ref{#1}}
  \newcommand\tabref[1]{\textbf{表}~\ref{#1}}
  \BOYOGALA@defname{authorname}{\citshape 作者：}
  \BOYOGALA@defname{institutename}{\citshape 组织：}
  \BOYOGALA@defname{datename}{\citshape 时间：}
  \BOYOGALA@defname{versionname}{\citshape 版本：}
  \BOYOGALA@defname{notename}{笔记}
  \BOYOGALA@defname{proofname}{证明}
  \BOYOGALA@defname{definitionname}{定义}
  \BOYOGALA@defname{theoremname}{定理}
  \BOYOGALA@defname{axiomname}{公理}
  \BOYOGALA@defname{postulatename}{公设}
  \BOYOGALA@defname{lemmaname}{引理}
  \BOYOGALA@defname{propositionname}{命题}
  \BOYOGALA@defname{corollaryname}{推论}
  \newcommand{\examplename}{例题} %
  \newcommand{\instancename}{示例} %
  \newcommand{\problemname}{问题} % 问题
  \newcommand{\exercisename}{练习} % 练习=习题
  \BOYOGALA@defname{remarkname}{注}
  \BOYOGALA@defname{assumptionname}{假设}
  \BOYOGALA@defname{conclusionname}{结论}
  \BOYOGALA@defname{solutionname}{解}
  \BOYOGALA@defname{propertyname}{性质}
  \BOYOGALA@defname{introductionname}{内容提要}
  \newcommand\bioinfo[2]{\gdef\@bioinfo{{\citshape #1}：#2}}
  \BOYOGALA@defname{updatename}{更新：}
  \BOYOGALA@defname{historyname}{版本更新历史}
  \BOYOGALA@defname{beforechap}{第}
  \BOYOGALA@defname{afterchap}{章}
}{\relax}


\ifdefstring{\BOYOGALA@lang}{en}{
  \setlength\parindent{2em}
  \newcommand\figref[1]{\textbf{Figure}~\ref{#1}}
  \newcommand\tabref[1]{\textbf{Table}~\ref{#1}}
  \BOYOGALA@defname{partname}{\color{structurecolor} Part}
  \BOYOGALA@defname{authorname}{\textbf{Author: }}
  \BOYOGALA@defname{institutename}{\textbf{Institute: }}
  \BOYOGALA@defname{datename}{\textbf{Date: }}
  \BOYOGALA@defname{versionname}{\textbf{Version: }}
  \BOYOGALA@defname{notename}{Note}
  \BOYOGALA@defname{proofname}{Proof}
  \BOYOGALA@defname{problemname}{Problem}
  \BOYOGALA@defname{definitionname}{Definition}
  \BOYOGALA@defname{theoremname}{Theorem}
  \BOYOGALA@defname{axiomname}{Axiom}
  \BOYOGALA@defname{postulatename}{Postulate}
  \BOYOGALA@defname{lemmaname}{Lemma}
  \BOYOGALA@defname{propositionname}{Proposition}
  \BOYOGALA@defname{corollaryname}{Corollary}
  \BOYOGALA@defname{examplename}{Example}
  \BOYOGALA@defname{exercisename}{Exercise}
  \BOYOGALA@defname{remarkname}{Remark}
  \BOYOGALA@defname{assumptionname}{Assumption}
  \BOYOGALA@defname{conclusionname}{Conclusion}
  \BOYOGALA@defname{solutionname}{Solution}
  \BOYOGALA@defname{propertyname}{Property}
  \BOYOGALA@defname{introductionname}{Introduction}
  \BOYOGALA@defname{appendixname}{Appendix}
  \BOYOGALA@defname{ebibname}{Bibliography}
  % \newcommand{\problemsetname}{Exercise}
  \newcommand\bioinfo[2]{\gdef\@bioinfo{\textbf{#1}: #2}}
  \BOYOGALA@defname{updatename}{Updates:}
  \BOYOGALA@defname{historyname}{Version History}
}{\relax}

% ---------- 繁体中文：结构名称 ----------
% 与简体中文共用同一套字体，差别只体现在这些名称上。
\ifdefstring{\BOYOGALA@lang}{cht}{
  \newcommand\figref[1]{\textbf{圖}~\ref{#1}}
  \newcommand\tabref[1]{\textbf{表}~\ref{#1}}
  \BOYOGALA@defname{contentsname}{目錄}
  \BOYOGALA@defname{figurename}{圖}
  \BOYOGALA@defname{tablename}{表}
  \BOYOGALA@defname{partname}{\color{structurecolor}}
  \BOYOGALA@defname{listfigurename}{插圖目錄}
  \BOYOGALA@defname{listtablename}{表格目錄}
  \BOYOGALA@defname{bibname}{參考文獻}
  \BOYOGALA@defname{appendixname}{附錄}
  \BOYOGALA@defname{indexname}{索\hspace{2em}引}
  \BOYOGALA@defname{authorname}{\citshape 作者：}
  \BOYOGALA@defname{institutename}{\citshape 組織：}
  \BOYOGALA@defname{datename}{\citshape 時間：}
  \BOYOGALA@defname{versionname}{\citshape 版本：}
  \BOYOGALA@defname{notename}{筆記}
  \BOYOGALA@defname{proofname}{證明}
  \BOYOGALA@defname{definitionname}{定義}
  \BOYOGALA@defname{theoremname}{定理}
  \BOYOGALA@defname{axiomname}{公理}
  \BOYOGALA@defname{postulatename}{公設}
  \BOYOGALA@defname{lemmaname}{引理}
  \BOYOGALA@defname{propositionname}{命題}
  \BOYOGALA@defname{corollaryname}{推論}
  \BOYOGALA@defname{examplename}{例題}
  \BOYOGALA@defname{instancename}{示例}
  \BOYOGALA@defname{problemname}{問題}
  \BOYOGALA@defname{exercisename}{練習}
  \BOYOGALA@defname{remarkname}{註}
  \BOYOGALA@defname{assumptionname}{假設}
  \BOYOGALA@defname{conclusionname}{結論}
  \BOYOGALA@defname{solutionname}{解}
  \BOYOGALA@defname{propertyname}{性質}
  \BOYOGALA@defname{introductionname}{內容提要}
  \BOYOGALA@defname{updatename}{更新：}
  \BOYOGALA@defname{ebibname}{參考文獻}
  \BOYOGALA@defname{historyname}{版本更新歷史}
  \newcommand\bioinfo[2]{\gdef\@bioinfo{{\citshape #1}：#2}}
}{\relax}


\graphicspath{{./figure/}{./figures/}{./image/}{./images/}{./graphics/}{./graphic/}{./pictures/}{./picture/}}

% List markers are taken from the maths font, so that no extra font is needed.
\newcommand*{\eitemi}{\ensuremath{\bullet}}
\newcommand*{\eitemii}{\ensuremath{\circ}}
\newcommand*{\eitemiii}{\ensuremath{\smblksquare}}
\setlist[enumerate,1]{label=\color{structurecolor}\arabic*.}
\setlist[enumerate,2]{label=\color{structurecolor}(\alph*).}
\setlist[enumerate,3]{label=\color{structurecolor}\Roman*.}
\setlist[enumerate,4]{label=\color{structurecolor}\Alph*.}
\setlist[itemize,1]{label={\eitemi}}
\setlist[itemize,2]{label={\eitemii}}
\setlist[itemize,3]{label={\eitemiii}}

\RequirePackage{apptools}

% appendix chapter:

\ifBOYOGALA@zh
  \ifdefstring{\BOYOGALA@scheme}{chinese}{%
    \newcommand{\xchaptertitle}{第\zhnumber{\arabic{chapter}}章}%
  }{%
    \newcommand{\xchaptertitle}{第 \thechapter{} 章}%
  }
  % 修正 hyperref 生成的章名，使目录与书签中显示“第 N 章”而不是纯数字
  % （hyperref 2022/05/16 起 nameref 总是被载入，见 issue#235）
  \AtBeginDocument{
    \ifBOYOGALA@Hy@later
      \patchcmd{\NR@chapter}%
        {\numberline{\thechapter}}{\numberline{\xchaptertitle}}%
        {}{\fail}
    \else
      \patchcmd{\Hy@org@chapter}%
        {\numberline{\thechapter}}{\numberline{\xchaptertitle}}%
        {}{\fail}
    \fi
  }
\else
  \newcommand{\xchaptertitle}{\chaptername~\thechapter~}
\fi

\setcounter{secnumdepth}{5}
\titleformat{\chapter}[\style]{\bfseries}{
  \filcenter\LARGE\enspace\bfseries{\color{structurecolor} \IfAppendix{\appendixname\;\thechapter\;}{\xchaptertitle\;}}}{1pt}{
  \LARGE\bfseries\color{structurecolor}\filcenter}[]
\titleformat{\section}[hang]{\bfseries}{
  \Large\bfseries{\color{structurecolor}\thesection}\enspace}{1pt}{%
  \color{structurecolor}\Large\bfseries\filright}
\titleformat{\subsection}[hang]{\bfseries}{
  \large\bfseries\color{structurecolor}\thesubsection\enspace}{1pt}{%
  \color{structurecolor}\large\bfseries\filright}
\titleformat{\subsubsection}[hang]{\bfseries}{
  \large\bfseries\color{structurecolor}\thesubsubsection\enspace}{1pt}{%
  \color{structurecolor}\large\bfseries\filright}

\titlespacing{\chapter}{0pt}{-20pt}{1.3\baselineskip}
%\titlespacing{\subsection}{0pt}{0.5\baselineskip}{-\baselineskip}


%%define the 
%%definition theorem postulate axiom corollary lemma proposition 
%%and proof environment
\RequirePackage[many]{tcolorbox}
% \newlength{\normalparindent}
% \setlength{\normalparindent}{\parindent}
\newcommand{\BOYOGALA@tmp@tl}{}
\ifBOYOGALA@usesamecnt
  \newcounter{BOYOGALA@samecnt}
  \counterwithin{BOYOGALA@samecnt}{\BOYOGALA@thmcnt}
  \tcbset{
    new/usesamecnt/.style = {use counter = BOYOGALA@samecnt}
  }
\else
  \tcbset{
    new/usesamecnt/.style = {}
  }
\fi

% ============================================================================
% 七、定理环境
% ============================================================================
% fancy 模式（默认）用 tcolorbox 实现彩色定理框，三种样式对应三种语义色：
%   defstyle  定义，主色 main
%   thmstyle  定理、引理、推论、公理、公设，辅色 second
%   prostyle 命题，强调色 third
% 计数器由 thmcnt 决定（按章或按节）；选项 usesamecnt 让所有定理环境
% 共用一个计数器；继承某个环境计数器的写法见 \elegantnewtheorem。
\ifdefstring{\BOYOGALA@mode}{fancy}{
  \tcbset{
    common/.style={
      fontupper=\citshape,
      lower separated=false,
      % before upper={\setlength{\parindent}{\normalparindent}},
      coltitle=white,
      colback=gray!5,
      boxrule=0.5pt,
      fonttitle=\bfseries,
      enhanced,
      breakable,
      top=8pt,
      before skip=8pt,
      attach boxed title to top left={
        yshift=-0.11in,
        xshift=0.15in},
      boxed title style={
        boxrule=0pt,
        colframe=white,
        arc=0pt,
        outer arc=0pt},
      separator sign={.},},
    defstyle/.style={
      common,
      colframe=main,  
      colback=main!5,
      colbacktitle=main, 
      overlay unbroken and last={
        \node[anchor=south east, outer sep=0pt] at (\linewidth-width,0) {
          \textcolor{main}{$\clubsuit$}};}},
    thmstyle/.style={
      common,
      colframe=second,  
      colback=second!5,
      colbacktitle=second, 
      overlay unbroken and last={
        \node[anchor=south east, outer sep=0pt] at (\linewidth-width,0) {
          \textcolor{second}{$\heartsuit$}};}},
    prostyle/.style={
      common,
      colframe=third,  
      colback=third!5,
      colbacktitle=third, 
      overlay unbroken and last={
        \node[anchor=south east, outer sep=0pt] at (\linewidth-width,0) {
          \textcolor{third}{$\spadesuit$}};}},
    BOYOGALA@title/.code n args={2}
      {

        \tcbset
          {
            title=
              {
                \csname #1name\endcsname~%
                \ifdef{\thetcbcounter}{\thetcbcounter}{}%
                \ifblank{#2}{}{\ (#2)}
              }
          }
      },
    BOYOGALA@label/.code n args={2}
      {
        \ifblank{#2}
          {}{\tcbset{label={#1:#2}}}
      }
    }
  
  % define an internal control sequence \BOYOGALA@newtheorem for fancy mode's newtheorem
  % #1 is the environment name, #2 is the prefix of label, #3 is the style
  % style: thmstyle, defstyle, prostyle
  % e.g. \BOYOGALA@newtheorem{theorem}{thm}{thmstyle}
  % will define two environments: numbered ``theorem'' and no-numbered ``theorem*''
  % WARNING FOR MULTILINGUAL: this cs will automatically find \theoremname's definition,
  % WARNING FOR MULTILINGUAL: it should be defined in language settings.
  \NewDocumentCommand \BOYOGALA@newtheorem { m m m O{} }{
    \ifcsundef{#1name}{%
      \ClassError{boyogalaelegantbook}{%
        \ #1name undefined, \MessageBreak
        Please check in language setting
      }{}
    }{\relax}
    \expandafter\ifblank\expandafter{#4}{
      \tcbset{
        new/usecnt/.style={}
      }
    }{
      \tcbset{
        new/usecnt/.style= {use counter from = #4}
      }
    }
    \DeclareTColorBox[auto counter,number within=\BOYOGALA@thmcnt,usesamecnt,usecnt]{#1}{ g o t\label g }{
        common,#3,
        IfValueTF={##1}
          {BOYOGALA@title={#1}{##1}}
          {
            IfValueTF={##2}
            {BOYOGALA@title={#1}{##2}}
            {BOYOGALA@title={#1}{}}
          },
        IfValueT={##4}
          {
            IfBooleanTF={##3}
              {label={##4}}
              {BOYOGALA@label={#2}{##4}}
          }
      }
    \DeclareTColorBox{#1*}{ g o }{
        common,#3,
        IfValueTF={##1}
          {BOYOGALA@title={#1}{##1}}
          {
            IfValueTF={##2}
            {BOYOGALA@title={#1}{##2}}
            {BOYOGALA@title={#1}{}}
          },
      }
  }
  % define several environment 
  % we define headers like \definitionname before
  \BOYOGALA@newtheorem{theorem}{thm}{thmstyle}
  \BOYOGALA@newtheorem{definition}{def}{defstyle}
  \BOYOGALA@newtheorem{postulate}{pos}{thmstyle}
  \BOYOGALA@newtheorem{axiom}{axi}{thmstyle}
  \BOYOGALA@newtheorem{corollary}{cor}{thmstyle}
  \BOYOGALA@newtheorem{lemma}{lem}{thmstyle}
  \BOYOGALA@newtheorem{proposition}{pro}{prostyle}
}{\relax}


% simple 模式改用 amsthm 的原生定理环境：样式与 fancy 一一对应，
% 但不使用彩色框，标题与正文的排布也交由 amsthm 处理。
\ifdefstring{\BOYOGALA@mode}{simple}{
  \let\openbox\relax
  \RequirePackage{amsthm}
  \let\proof\relax
  % \let\proofname\relax
  \let\endproof\relax

  % declare new theorem styles: defstyle, thmstyle, prostyle
  \newtheoremstyle{defstyle}{3pt}{3pt}{\citshape}{-3pt}{
    \bfseries\color{main}}{}{0.5em}{\thmname{#1} \thmnumber{#2} \thmnote{(#3)}}
  \newtheoremstyle{thmstyle}{3pt}{3pt}{\citshape}{-3pt}{
    \bfseries\color{second}}{}{0.5em}{\thmname{#1} \thmnumber{#2} \thmnote{(#3)}}
  \newtheoremstyle{prostyle}{3pt}{3pt}{\citshape}{-3pt}{
    \bfseries\color{third}}{}{0.5em}{\thmname{#1} \thmnumber{#2} \thmnote{(#3)}}

  % define an internal control sequence \BOYOGALA@newtheorem for simple mode's newtheorem
  % #1 is the environment name, #2 is the style
  % style: thmstyle, defstyle, prostyle
  % e.g. \BOYOGALA@newtheorem{theorem}{thmstyle}
  % will define two environments: numbered ``theorem'' and no-numbered ``theorem*''
  % WARNING FOR MULTILINGUAL: this cs will automatically find \theoremname's definition,
  % WARNING FOR MULTILINGUAL: it should be defined in language settings.
  \NewDocumentCommand \BOYOGALA@newtheorem { m m O{} } {
    \theoremstyle{#2}
    \ifBOYOGALA@usesamecnt
      \newtheorem{#1}[BOYOGALA@samecnt]{\csname #1name\endcsname}
    \else 
      \ifblank{#3}{
        \newtheorem{#1}{\csname #1name\endcsname}[\BOYOGALA@thmcnt]
      }{
        \newtheorem{#1}[#3]{\csname #1name\endcsname}
      }
    \fi
    \newtheorem*{#1*}{\csname #1name\endcsname}
  }

  % define several environment 
  % we define headers like \definitionname before
  \BOYOGALA@newtheorem{theorem}{thmstyle}
  \BOYOGALA@newtheorem{definition}{defstyle}
  \BOYOGALA@newtheorem{postulate}{thmstyle}
  \BOYOGALA@newtheorem{axiom}{thmstyle}
  \BOYOGALA@newtheorem{corollary}{thmstyle}
  \BOYOGALA@newtheorem{lemma}{thmstyle}
  \BOYOGALA@newtheorem{proposition}{prostyle}
}{\relax}

% define an user control sequence \elegantnewtheorem
% #1 is the evironment, #2 is the theorem header
% #3 is the style       #4 is the prefix for fancy mode
% style: thmstyle, defstyle, prostyle
% if #4 is given in simple mode, an error will be raised
% if #4 isn't given in fancy mode, the prefix will be set equal to #1,
%   and a warning will be raised
% 用户接口：\elegantnewtheorem{环境名}{标题}{样式}[前缀][继承的计数器]
%   样式  取 defstyle、thmstyle、prostyle 三者之一；
%   前缀  用于生成标签前缀，如 thm:label，只在 fancy 模式下有意义；
%   继承  指定与哪个已有环境共用计数器。
% 该命令同时定义带编号的 env 与不编号的 env* 两套环境。
\newcommand{\BOYOGALA@newtheorem@warning}{}
\newcommand{\BOYOGALA@newtheorem@error}{}
\newcommand{\BOYOGALA@usesamecnt@warning}{}
\NewDocumentCommand\elegantnewtheorem{ m m m g O{} }
  {
    \renewcommand{\BOYOGALA@usesamecnt@warning}{
      \ClassWarning{boyogalaelegantbook}{%
        [#5] won't make sence with option \MessageBreak
        `usesamecnt'.
      }
    }
    \renewcommand{\BOYOGALA@newtheorem@warning}{
      \ClassWarning{boyogalaelegantbook}{%
        Because you didn't provide a prefix, \MessageBreak
        we use #1 as the default prefix. \MessageBreak
        You have to use \MessageBreak
        \ref{#1:label} to refer a \MessageBreak
        \begin{#1}{name}{label} environment. \MessageBreak
      }
    }
    \renewcommand{\BOYOGALA@newtheorem@error}{
      \ClassError{boyogalaelegantbook}{%
        You can't set a prefix in mode ``simple''.\MessageBreak
        Just use \MessageBreak
        \elegantnewtheorem{#1}{#2}{#3}
      }{%
        We are using ``amsthm'' package to \MessageBreak
        generate theorem-like theorem. \MessageBreak
        The 4th parameter ``prefix'' isn't allowed.
      }
    }
    \ifBOYOGALA@usesamecnt
      \ifblank{#5}{}{\BOYOGALA@usesamecnt@warning}
    \else
      \renewcommand{\BOYOGALA@tmp@tl}{#5}
    \fi
    \expandafter\def\csname #1name\endcsname{#2}
    \ifdefstring{\BOYOGALA@mode}{simple}{%
        \IfValueTF{#4}
          {\BOYOGALA@newtheorem@error}
          {\BOYOGALA@newtheorem{#1}{#3}[\BOYOGALA@tmp@tl]}
      }{\relax}
    \ifdefstring{\BOYOGALA@mode}{fancy}{%
        \IfValueTF{#4}
          {
            \def\BOYOGALA@temp@prefix{#4}
            \ifdefempty{\BOYOGALA@temp@prefix}
              {
                \BOYOGALA@newtheorem{#1}{#1}{#3}[\BOYOGALA@tmp@tl]
                \BOYOGALA@newtheorem@warning
              }
              {\BOYOGALA@newtheorem{#1}{#4}{#3}[\BOYOGALA@tmp@tl]}
          }
          {
            \BOYOGALA@newtheorem{#1}{#1}{#3}[\BOYOGALA@tmp@tl]
            \BOYOGALA@newtheorem@warning
          }
      }{\relax}
  }

% main（green-def): example exercise problem solution
% second（orange-thm）: proof note remark  
% third（blue-prop):  assumptions property conclusion custom

% 示例类环境：example、exercise、problem 按章编号，note 带引导符，
% proof、solution、remark、assumption、conclusion、property 为普通段落环境。
%% Example with counter
\newcounter{exam}[chapter]
\setcounter{exam}{0}
\renewcommand{\theexam}{\thechapter.\arabic{exam}}
\newenvironment{example}[1][]{
  \refstepcounter{exam}
  \par\noindent\textbf{\color{main}{\examplename} \theexam #1 }\rmfamily}{
  \par\ignorespacesafterend}

%% Exercise with counter
\newcounter{exer}[chapter]
\setcounter{exer}{0}
\renewcommand{\theexer}{\thechapter.\arabic{exer}}
\newenvironment{exercise}[1][]{
  \refstepcounter{exer}
  \par\noindent\makebox[-3pt][r]{
    \scriptsize\color{red!90}\ensuremath{\blacktriangleright}\quad}
    \textbf{\color{main}{\exercisename} \theexer #1 }\rmfamily}{
    \par\ignorespacesafterend}

%% Problem with counter
\newcounter{prob}[chapter]
\setcounter{prob}{0}
\renewcommand{\theprob}{\thechapter.\arabic{prob}}
\newenvironment{problem}[1][]{
  \refstepcounter{prob}
  \par\noindent\textbf{\color{main}{\problemname} \theprob #1 }\rmfamily}{
  \par\ignorespacesafterend}

\newenvironment{note}{
  \par\noindent\makebox[-3pt][r]{
    \scriptsize\color{red!90}\ensuremath{\blacktriangleright\!\blacktriangleright}\quad}
    \textbf{\color{second}\notename} \citshape}{\par}

\newenvironment{proof}{
  \par\noindent\textbf{\color{second}\proofname\;}
  \color{black!90}\cfs}{
  % \hfill$\Box$\quad
  \par}

\newenvironment{solution}{\par\noindent\textbf{\color{main}\solutionname} \citshape}{\par}
\newenvironment{remark}{\noindent\textbf{\color{second}\remarkname}}{\par}
\newenvironment{assumption}{\par\noindent\textbf{\color{third}\assumptionname} \citshape}{\par}
\newenvironment{conclusion}{\par\noindent\textbf{\color{third}\conclusionname} \citshape}{\par}
\newenvironment{property}{\par\noindent\textbf{\color{third}\propertyname} \citshape}{\par}
\newenvironment{custom}[1]{\par\noindent\textbf{\color{third} #1} \citshape}{\par}

\tcbset{
  introductionsty/.style={
    enhanced,
    breakable,
    colback=structurecolor!10,
    colframe=structurecolor,
    fonttitle=\bfseries,
    colbacktitle=structurecolor,
    fontupper=\citshape,
    attach boxed title to top center={yshift=-3mm,yshifttext=-1mm},
    boxrule=0pt,
    toprule=0.5pt,
    bottomrule=0.5pt,
    top=8pt,
    before skip=8pt,
    sharp corners
  },
}


% 章节摘要（introduction）：双栏要点框；章末习题（problemset）：自动进入目录。
\newenvironment{introduction}[1][\introductionname]{
  \begin{tcolorbox}[introductionsty,title={#1}]
    \begin{multicols}{2}
      \begin{itemize}[label=\textcolor{structurecolor}{\upshape\scriptsize\ensuremath{\mdlgblksquare}}]}{
      \end{itemize}
    \end{multicols}
  \end{tcolorbox}}


\newenvironment{problemset}[1][\xchaptertitle~\exercisename]{
  \vspace*{10pt}
  \begin{center}
    \phantomsection\addcontentsline{toc}{section}{\texorpdfstring{\xchaptertitle~\exercisename}{\exercisename}}
    % \markboth{#1}{\rightmark}
    \markright{#1}
    \textcolor{structurecolor}{\Large\bfseries\ensuremath{\mdlgblkdiamond}~#1~\ensuremath{\mdlgblkdiamond}}
  \end{center}
  \begin{enumerate}}{
  \end{enumerate}}

\def\relsec{\endgroup start}
\def\endrelsec{end\begingroup\def \@currenvir {relsec}}

\ifdefstring{\BOYOGALA@result}{noanswer}{
  \AtBeginDocument{
  \excludecomment{solution}
  \excludecomment{proof}
  \excludecomment{inline}
  }
}{\relax}


%页眉页脚
% ============================================================================
% 九、页眉页脚
% ============================================================================
% 页眉显示章名（中文为“第 N 章”）与节名，页脚居中显示页码。
\RequirePackage{fancyhdr}
\fancyhf{}


\fancyfoot[c]{\color{structurecolor}\small\thepage}
\if@twoside
  \fancyhead[EL]{\color{structurecolor}\cnormal\leftmark}
  \fancyhead[OR]{\color{structurecolor}\cnormal\rightmark}
\else
  \fancyhead[R]{\color{structurecolor}\cnormal\rightmark}
\fi

\renewcommand{\headrule}{\color{structurecolor}\hrule width\textwidth}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{1pt}
% \renewcommand{\headrule}{}
\fancypagestyle{plain}{\renewcommand{\headrulewidth}{0pt}\fancyhf{}\renewcommand{\headrule}{}}
\renewcommand{\sectionmark}[1]{\markright{\thesection\, #1}{}}
\renewcommand{\chaptermark}[1]{\markboth{\IfAppendix{\appendixname\;\thechapter\, #1}{\xchaptertitle\, #1}}{}}


% ============================================================================
% 八、封面
% ============================================================================
% 覆写 \maketitle，整页排版，自上而下依次为：封面图、色条、标题、
% 作者信息与徽标、箴言。未提供封面图时用浅灰色块占位。
\renewcommand*{\maketitle}{%
\hypersetup{pageanchor=false}
\pagenumbering{Alph}
\begin{titlepage}
  \newgeometry{margin = 0in}
  \parindent=0pt
  \ifdefstring{\BOYOGALA@device}{normal}{
    \ifcsname @cover\endcsname
      \includegraphics[width=\linewidth]{\@cover}
    \else
      {\color{black!10}\rule{\linewidth}{0.8\linewidth}}%
    \fi
  }{\relax}
  \ifdefstring{\BOYOGALA@device}{pad}{
    \ifcsname @cover\endcsname
      \includegraphics[trim=0 26bp 0 26bp,clip=true, width=\linewidth]{\@cover}
    \else
      {\color{black!10}\rule{\linewidth}{0.8\linewidth}}%
    \fi
  }{\relax}
  \vskip-\baselineskip
  {\color{coverlinecolor}\hrule \@width \linewidth \@height .5in}
  \vfill
  \vskip-2ex
  \hspace{2em}
  \parbox{0.8\textwidth}{
    \bfseries\Huge 
      \ifcsname @title\endcsname \@title \fi
    \par}
  \vfill
  \vspace{-1.0cm}
  \setstretch{2.5}
  \hspace{2.5em}
  \begin{minipage}[c]{0.67\linewidth}
    {\color{darkgray}\bfseries\Large
      \ifcsname @subtitle\endcsname\@subtitle\\[2ex]\fi}
    \color{gray}\normalsize
    {\renewcommand{\arraystretch}{0.618}
    \begin{tabular}{l}
      % \ifcsname @author\endcsname \authorname \@author\\\fi
      \ifx\@author\empty\else\authorname\cnormal\@author\\ \fi
      \ifcsname @institute\endcsname \institutename \cnormal\@institute\\ \fi
      % \ifcsname @date\endcsname  \@date\\\fi
      \ifx\@date\empty\else\datename\cnormal\@date \\ \fi
      \ifcsname @version\endcsname \cnormal\versionname\@version\\ \fi
      \ifcsname @bioinfo\endcsname \cnormal\@bioinfo\\ \fi
    \end{tabular}}
  \end{minipage}
  \begin{minipage}[b]{0.27\linewidth}
    \raggedleft
    \ifcsname @logo\endcsname
      \includegraphics[width=4.2cm]{\@logo}%
    \fi
  \end{minipage}
  \vfill
  \begin{center}
    \setstretch{1.3}
    \parbox[t]{0.7\textwidth}{\centering \citshape 
      \ifcsname @extrainfo\endcsname\@extrainfo\fi}
  \end{center}
  \vfill
\end{titlepage}
\restoregeometry
\thispagestyle{empty}}


\newcommand{\dollar}{\mbox{\textdollar}}

% ============================================================================
% 十、代码
% ============================================================================
% listings 提供代码高亮，等宽字体为 JetBrains Mono。
% showstringspaces=false 关闭字符串内空格的可见标记：否则该标记会引入
% TeX 发行版自带的 CM 字体，破坏“只使用 fonts/ 中字体”的约定。
\RequirePackage{listings}
\lstdefinestyle{mystyle}{
  basicstyle=%
    \ttfamily
    \lst@ifdisplaystyle\small\fi
}

\lstset{basicstyle=\ttfamily,style=mystyle,breaklines=true,showstringspaces=false}

\definecolor{lightgrey}{rgb}{0.9,0.9,0.9}
\definecolor{frenchplum}{RGB}{190,20,83}
\lstset{language=[LaTeX]TeX,
  texcsstyle=*\color{winered},
  numbers=none,
  mathescape=false,
  breaklines=true,
  keywordstyle=\color{winered},
  commentstyle=\color{gray},
  emph={fontenc,fontspec,xeCJK,citestyle,xunicode,figure,fig,image,img,table,itemize,enumerate,ctex,microtype,description,booktabs,tabular,XeLaTeX,latexmk,BibTeX,biber,device,color,mode,lang,amsthm,tcolorbox,titlestyle,cite,listings,scheme,toc,amsmath,unicode-math,bibstyle,bibend,addbibresource,printbibliography},
  emphstyle={\color{frenchplum}},
  morekeywords={toprule,midrule,bottomrule,institute,version,includegraphics,setmainfont,setsansfont,setmonofont,setCJKmainfont,setCJKsansfont,setCJKmonofont,RequirePackage,figref,tabref,email,maketitle,definecolor,extrainfo,logo,cover,subtitle,appendix,chapter,section,hypersetup,mainmatter,frontmatter,tableofcontents,heiti,kaishu,lstset,pagecolor,zhnumber,marginpar,part,marginnote,bioinfo,datechange,listofchanges,songti,fangsong,setCJKfamilyfont,textbf,elegantnewtheorem,thmcnt,colorlet,usesamecnt,symbf,setmathfont},
  frame=single,
  tabsize=2,
  rulecolor=\color{structurecolor},
  framerule=0.2pt,
  columns=flexible,
  % backgroundcolor=\color{lightgrey}
}


% ============================================================================
% 十一、修订历史
% ============================================================================
% \datechange{日期}{说明} 记录一条修订，change 环境列出该版本的改动，
% \listofchanges 生成修订历史目录（数据存放于 .dates 辅助文件，需编译两次）。
% add the list of change history
\newcommand{\dateinfoline}[2]{
  \noindent\makebox[0pt][r]{%
  \makebox[-3em][r]{%
    \small
    \textbf{\textcolor{structurecolor}{#1}}}\;\;}%
  {\citshape\updatename\ignorespaces#2}}

\newcommand{\datechange}[2]{%
  \noindent{\makebox[\textwidth][r]{\color{structurecolor}\rule{1.15\textwidth}{.4pt}}}
  \dateinfoline{#1}{#2}
  \addcontentsline{dates}{section}{#1 -- #2}}

\newcommand{\listofchanges}{%
  \begingroup
    \BOYOGALA@defname{contentsname}{\historyname}
    \let\old@starttoc\@starttoc
    \def\@starttoc##1{
      \old@starttoc{dates}}
    \tableofcontents%
  \endgroup}
% https://tex.stackexchange.com/questions/472931/list-of-all-dates-in-a-document

\newenvironment{change}{
  \begin{enumerate}[label=\small\arabic*.]}{
  \end{enumerate}}


\renewcommand\tableofcontents{%
  \hypersetup{linktoc=all, linkcolor=black}
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \ifdefstring{\BOYOGALA@toc}{twocol}{
      \setlength{\columnsep}{2em}
      \begin{multicols}{2}%
        \@starttoc{toc}
      \end{multicols}}{
      \@starttoc{toc}}
    \if@restonecol\twocolumn\fi
    \hypersetup{linkcolor=winered}}


\renewcommand*{\cleardoublepage}{\clearpage\if@twoside \ifodd\c@page\else
\hbox{}%
\thispagestyle{empty}%
\newpage%
\if@twocolumn\hbox{}\newpage\fi\fi\fi}


% ============================================================================
% 十三、目录
% ============================================================================
% tocloft 定制目录中的章名编号：中文为“第 N 章”，英文为 Chapter N；
% 附录另作处理。参考：
% https://tex.stackexchange.com/questions/56839/chaptername-is-used-even-for-appendix-chapters-in-toc
% https://tex.stackexchange.com/questions/56839/chaptername-is-used-even-for-appendix-chapters-in-toc
\RequirePackage{calc}
\RequirePackage[titles]{tocloft}
\ifBOYOGALA@zh
  % \renewcommand{\cftchappresnum}{\beforechap\space}
  % \renewcommand{\cftchapaftersnum}{\space\afterchap}
  % \setlength{\cftchapnumwidth}{\widthof{\textbf{附录~十一}}}
  \renewcommand{\numberline}[1]{%
  \@cftbsnum #1\@cftasnum~\@cftasnumb ~%
  }
  \g@addto@macro\appendix{%
    % recover \thechapter in the \NR@chapter's \numberline
    \ifBOYOGALA@Hy@later
      \patchcmd{\NR@chapter}%
        {\numberline{\xchaptertitle}}{\numberline{\thechapter}}%
        {}{\fail}      
    \else
      \patchcmd{\Hy@org@chapter}%
        {\numberline{\xchaptertitle}}{\numberline{\thechapter}}%
        {}{\fail}  
    \fi
    \addtocontents{toc}{%
      \protect\renewcommand{\protect\cftchappresnum}{\appendixname\space}%
      \protect\renewcommand{\protect\cftchapaftersnum}{}%
    }%
  }
\else
  \renewcommand{\cftchappresnum}{\chaptername\space}
  \renewcommand{\cftchapaftersnum}{\space}
  \setlength{\cftchapnumwidth}{\widthof{\textbf{Appendix~9}}}
  \g@addto@macro\appendix{%
    \addtocontents{toc}{%
      \protect\renewcommand{\protect\cftchappresnum}{\appendixname\space}%
      \protect\renewcommand{\protect\cftchapaftersnum}{}%
      \setlength{\cftchapnumwidth}{\widthof{\textbf{Appendix~999}}}
    }%
  }
\fi

