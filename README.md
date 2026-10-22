# BoyogalaElegantBook：开源免费的优美 LaTeX 书籍模板

BoyogalaElegantBook 是 [ElegantBook](https://github.com/ElegantLaTeX/ElegantBook) 的精简与现代化分支：只保留一种字体配置，去除冗余选项与多余依赖，编译更快，跨平台排版结果一致。

## 微信公众号：博優旮旯-BOYOGALA

本项目的作者有同名公众号，欢迎扫码关注作者的微信公众号：

<p align="center"><img src="boyogala.png" width="64%"></p>

一起走进优化求解器与数值计算的科普分享.


> 本项目是非官方分支，与 ElegantLaTeX 团队无隶属关系；上游项目的版权与致谢见文末。

## 特点

- **唯一字体配置**：所有西文、中文与数学字体随项目提供，集中在 `fonts/` 目录，不再有 `math`、`chinesefont` 等字体选项，也不依赖系统字体。
- **只支持 XeLaTeX**：字体统一由 `fontspec` 与 `unicode-math` 加载，使用其它引擎会直接报错。
- **三种语言**：简体中文（`lang=cn`）、繁体中文（`lang=cht`）与英文（`lang=en`），其它语言已移除。
- **依赖精简**：类文件的宏包加载从 63 处减至 30 处，移除了 `tikz`、`mwe`、`lipsum`、`makecell`、`hologo` 等非必要宏包；装饰符号改用数学字体中的字形。
- **注释详尽**：类文件与两份主文件均配有中文功能注释，便于阅读与二次开发。
- **许可清晰**：模板遵循 LPPL 1.3c，全部字体遵循 SIL OFL 1.1。

## 目录结构

```
BoyogalaElegantBook/
├── boyogalaelegantbook.cls      % 类文件
├── boyogalaelegantbook-cn.tex   % 中文手册
├── boyogalaelegantbook-en.tex   % 英文手册
├── chapters/                    % 各章内容，由主文件 \input 调用
│   ├── chap-algorithm.tex       % 例：算法流程（线性规划的单纯形法）
│   └── chap-graph.tex           % 例：图论（图的表示、度与最短路）
├── fonts/                       % 字体文件（必须保留）
├── figure/, image/              % 封面与插图
├── reference.bib                % 示例参考文献
└── LICENSE                      % LPPL 1.3c 许可证
```

## 编译

**请在项目根目录下用 XeLaTeX 编译**（字体路径是相对路径 `./fonts/`，在其它目录中编译会找不到字体）：

```bash
xelatex boyogalaelegantbook-cn.tex
# 或
latexmk -xelatex boyogalaelegantbook-cn.tex
```

中文手册需要连续编译两次（目录、交叉引用与修订历史需要读回辅助文件）；用 `latexmk` 会自动完成。

### 在 Overleaf 上使用

把整个项目目录（含 `fonts/`）打包上传到 [Overleaf](https://www.overleaf.com/)，在菜单中把编译器设为 **XeLaTeX** 即可。注意免费版 Overleaf 有编译时长限制，完整的 93 MB 字体目录会让首次编译稍慢。

## 字体方案

| 用途 | 字体 | 文件 |
| --- | --- | --- |
| 西文正体 | STIX Two Text | `STIXTwoText-{Regular,Bold,Italic,BoldItalic}.otf` |
| 西文无衬线 | Source Sans 3 | `SourceSans3-{Regular,Bold,It,BoldIt}.otf` |
| 等宽（代码） | JetBrains Mono | `JetBrainsMono-{Regular,Bold,Italic,BoldItalic}.ttf` |
| 数学 | STIX Two Math | `STIXTwoMath-Regular.otf` |
| 中文正文（宋） | Source Han Serif SC | `SourceHanSerifSC-Regular.otf` |
| 中文标题（黑） | Source Han Sans SC | `SourceHanSansSC-{Regular,Bold}.otf` |
| 中文强调（楷） | LXGW WenKai | `LXGWWenKai-Regular.ttf` |
| 中文引文（仿宋） | Zhuque Fangsong | `ZhuqueFangsong-Regular.ttf` |

中文保留宋、黑、楷、仿宋四种角色，与原 ElegantBook 的排版结构一致：宋体用于正文，黑体用于粗体与标题，楷体用于定理类环境正文与斜体，仿宋用于证明环境正文。对应命令为 `\songti`、`\heiti`、`\kaishu`、`\fangsong`。

所有字体的许可证均为 SIL Open Font License 1.1，版权声明与许可证全文见 [`fonts/OFL.txt`](fonts/OFL.txt)。

## 多文件书稿

长篇书稿建议把每一章放进 `chapters/` 目录，由主文件统一调用：

```latex
\input{chapters/chap-algorithm}
\input{chapters/chap-graph}
```

`\input` 只做文件展开，章节文件不能单独编译，但编译速度快；`\include` 会为每章建立独立的辅助文件与书签，可配合 `\includeonly` 只编译指定章节。详见中文手册第 4 章。

## 安装

本项目采用“免安装”方式使用：下载整个项目目录即可，无需安装到 TeX 发行版中。需要的宏包（`fontspec`、`xeCJK`、`ctex`、`unicode-math`、`tcolorbox`、`titlesec`、`fancyhdr`、`tocloft`、`biblatex` 等）均包含在 TeX Live 的完整安装中。

## 许可证与致谢

- 模板代码遵循 [LaTeX Project Public License 1.3c](LICENSE)，可自由使用、修改与再分发。
- `fonts/` 下的全部字体遵循 [SIL Open Font License 1.1](fonts/OFL.txt)。
- 封面图片来自 [pixabay.com](https://pixabay.com/en/tea-time-poetry-coffee-reading-3240766/)，可免费使用。

BoyogalaElegantBook 源自 [Ethan Deng](https://github.com/EthanDeng) 与 [Liam Huang](https://github.com/Liam0205) 创立的 [ElegantBook](https://github.com/ElegantLaTeX/ElegantBook)，后由 [Ethan Deng](https://github.com/EthanDeng)、[乙醇](https://github.com/syvshc) 与 [死抠](https://github.com/sikouhjw) 维护。感谢上游项目及其全部贡献者。

## 反馈

- 问题与建议：<https://github.com/boyogala/BoyogalaElegantBook/issues>
- 邮箱：<boyogala@qq.com>
