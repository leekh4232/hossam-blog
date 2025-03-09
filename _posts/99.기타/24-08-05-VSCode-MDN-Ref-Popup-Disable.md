---
title:  "Visual Studio Code MDN 레퍼런스 팝업 비활성화"
description: 웹 개발 관련 수업을 진행하거나 웹 페이지 구성 파일을 코딩할 때 VSCode에서 태그 이름이나 CSS 속성 등에 마우스를 올리면 MDN 레퍼런스가 팝업으로 뜨는데 이게 여간 성가신게 아니다. 이를 비활성화 하기 위해 환경설정에 다음의 코드를 추가한다.
categories: [99.컴퓨터활용,VSCode]
date:   2024-08-05 23:13:00 +0900
author: Hossam
image:
  path: /images/photo/study-cafe.png
tags: [tip & tach,vscode]
pin: true
math: true
mermaid: true
---


```json
{
    "css.hover.references": false,
    "less.hover.references": false,
    "scss.hover.references": false,
    "html.hover.references": false,
    "html.hover.documentation": false,
    "editor.codeLens": false
}
```