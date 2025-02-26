---
layout: post
title:  "Visual Studio Code MDN 레퍼런스 팝업 비활성화"
date:   2024-08-05
banner_image: photo/study-cafe.png
tags: [Tip&Tech]
---

웹 개발 관련 수업을 진행하거나 웹 페이지 구성 파일을 코딩할 때 VSCode에서 태그 이름이나 CSS 속성 등에 마우스를 올리면 MDN 레퍼런스가 팝업으로 뜨는데 이게 여간 성가신게 아니다.

<!--more-->


이를 비활성화 하기 위해 환경설정에 다음의 코드를 추가한다.

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