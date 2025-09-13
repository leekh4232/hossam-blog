---
title:  "VSCode에서 프로젝트를 열면 자동으로 Pull 받기"
description: 노트북을 정리하고 맥스튜디오로 갈아탄지 1년쯤 되었다. 외장하드 하나 들고 다니면서 작업하는게 무척 만족스럽다. 한가지 단점은 집에 있는 맥스튜디오와 외장하드간 동기화를 위해 Git에서 Pull을 자주 받아야 된다는 점이다.
categories: [91.기타,미분류]
date:   2025-07-08 12:43:33 +0900
author: Hossam
image: /images/indexs/study-cafe.png
tags: [tip & tach,vscode,정규표현식]
pin: true
math: true
mermaid: true
---

## 프로젝트 폴더 안에 .vscode/tasks.json 파일 만들기

직접 폴더와 파일을 추가하고 아래의 코드를 적용한다.

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Git Pull On Startup",
      "type": "shell",
      "command": "git pull",
      "problemMatcher": [],
      "runOptions": {
        "runOn": "folderOpen"
      }
    }
  ]
}
```

이제 `.vscode`폴더가 포함되는 프로젝트를 git으로 열 때, VSCode가 자동으로 Pull을 받게 된다.