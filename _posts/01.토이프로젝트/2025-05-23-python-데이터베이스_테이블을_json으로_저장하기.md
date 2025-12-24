---
title:  "데이터베이스 테이블을 JSON으로 저장하기"
description: "작업중에 필요해서 만든 코드"
categories: [01.Toy Project, 유틸리티]
date: 2025-05-23 12:39:33
author: Hossam
image: /images/indexs/python.jpg
tags: [Programming,Coding,Python,Utility]
pin: true
math: true
mermaid: true
---

MySQL이나 MariaDB의 데이터를 활용해서 Json-Server용 데이터 파일을 생성하기 위해 작성한 스크립트.

```python
import json
import pymysql

config = {
    "host": "DB주소",
    "port": 포트번호,
    "user": "사용자이름",
    "password": "비밀번호",
    "dbname": "데이터베이스",
    "charset": "문자셋(utf8mb4)",
    "table": "테이블이름"
}

# MariaDB 연결 정보
conn = pymysql.connect(
    host=config['host'], user=config['user'], password=config['password'],
    port=config['port'], db=config['dbname'], charset=config['charset'])
cur = conn.cursor(pymysql.cursors.DictCursor)

# 전체 데이터 조회
cur.execute("SELECT * FROM %s;" % config['table'])
rows = cur.fetchall()

# JSON 파일로 저장
with open('%s.json' % config['table'], 'w', encoding='utf-8') as f:
    json.dump(rows, f, ensure_ascii=False, indent=2,
              default=lambda x: x if isinstance(x, int) or isinstance(x, float) else str(x)
    )

cur.close()
conn.close()
```