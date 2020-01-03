---
title: xelatex 纸张大小设置
id: 38
categories:
  - 百度空间的旧文章
date: 2015-05-19 06:06:28
tags:
---

\documentclass[]{article}

\usepackage[T1]{fontenc}

\usepackage{lmodern}

\usepackage{amssymb,amsmath}

\usepackage{ifxetex,ifluatex}

**\usepackage[body={18cm,24cm}]{geometry}**

**\geometry{papersize={21cm,29.7cm}}**

\usepackage{fixltx2e} % provides \textsubscript

% use microtype if available

\IfFileExists{microtype.sty}{\usepackage{microtype}}{}

% use upquote if available, for straight quotes in verbatim environments

注意加粗的两行。

&nbsp;