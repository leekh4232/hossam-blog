---
title:  "파이썬 API 문서 자동 생성하기"
description: "자신만의 모듈을 만들고 나면 함수나 클래스 단위로 주석을 작성합니다. 이 주석을 읽어들여서 레퍼런스 문서를 자동으로 생성해 주는 기능을 소개합니다."
categories: [03.Coding,Python]
date:   2024-03-25 11:33:00 +0900
author: Hossam
image: /images/indexs/python.jpg
tags: [Programming,Coding,Python]
pin: true
math: true
mermaid: true
---


# #01. 모듈화 기능의 주석문 예시

파이썬에서 함수 단위의 주석은 아래와 같은 형식으로 작성됩니다.

```python
def my_normalize_data(
    mean: float, std: float, size: int = 100, round: int = 2
) -> np.ndarray:
    """정규분포를 따르는 데이터를 생성한다.

    Args:
        mean (float): 평균
        std (float): 표준편차
        size (int, optional): 데이터 크기. Defaults to 1000.

    Returns:
        np.ndarray: 정규분포를 따르는 데이터
    """
    p = 0
    x = []
    while p < 0.05:
        x = np.random.normal(mean, std, size).round(round)
        _, p = normaltest(x)

    return x
```

# #02. 레퍼런스 생성 자동화 하기

## [1] 패키지 설치

pdoc 이라는 패키지를 설치합니다.

```shell
pip install pdoc
```

## [2] 문서 생성

작업 폴더 위치에서 명령 수행

```shell
pdoc --html --output-dir 생성될폴더이름 패키지폴더이름
```

### 사용 예

```shell
pdoc --html --output-dir docs helper
```

## [3] 고급 옵션

```shell
# 브라우저에서 자동으로 열기
pdoc --html --output-dir docs --browse helper

# 서버 모드로 실행 (실시간 업데이트)
pdoc --http localhost:8080 helper

# 외부 링크 포함하여 생성
pdoc --html --output-dir docs --external-links helper

# 특정 모듈만 문서화
pdoc --html --output-dir docs helper.utils

# 프라이빗 멤버 포함
pdoc --html --output-dir docs --show-source helper
```

# #03. 다양한 문서화 도구 비교

## 1) pdoc vs 다른 도구들

| 도구 | 장점 | 단점 | 사용 상황 |
|------|------|------|-----------|
| **pdoc** | 간단한 설정, 빠른 생성 | 커스터마이징 제한적 | 개인 프로젝트, 빠른 문서화 |
| **Sphinx** | 강력한 기능, 확장성 | 복잡한 설정, 학습 곡선 | 대규모 프로젝트, 공식 문서 |
| **MkDocs** | Markdown 지원, 테마 풍부 | Python 특화 기능 부족 | 일반적인 문서 사이트 |
| **pydoc** | 내장 도구, 추가 설치 불필요 | 기본적인 기능만 제공 | 간단한 확인용 |

## 2) Sphinx 사용하기

### 설치 및 설정

```shell
pip install sphinx sphinx-rtd-theme
```

### 프로젝트 초기화

```shell
# 문서 디렉토리 생성
mkdir docs
cd docs

# Sphinx 프로젝트 초기화
sphinx-quickstart
```

### conf.py 설정 예시

```python
# Configuration file for the Sphinx documentation builder.

import os
import sys
sys.path.insert(0, os.path.abspath('..'))

project = 'My Python Project'
author = 'Your Name'
release = '1.0.0'

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'sphinx.ext.intersphinx',
]

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

# Napoleon settings (Google/NumPy 스타일 docstring 지원)
napoleon_google_docstring = True
napoleon_numpy_docstring = True
napoleon_include_init_with_doc = False
napoleon_include_private_with_doc = False
```

### 자동 문서 생성

```shell
# API 문서 자동 생성
sphinx-apidoc -o . ../myproject

# HTML 빌드
make html
```

# #04. 고급 주석 작성 가이드

## 1) Google 스타일 Docstring

```python
def calculate_statistics(data, method='mean', axis=None):
    """Calculate statistics for the given data.

    This function calculates various statistical measures for the input data
    using different methods.

    Args:
        data (array_like): Input data array.
        method (str, optional): Statistical method to use.
            Options are 'mean', 'median', 'std'. Defaults to 'mean'.
        axis (int, optional): Axis along which to calculate statistics.
            If None, calculate for flattened array. Defaults to None.

    Returns:
        float or ndarray: Calculated statistic value(s).

    Raises:
        ValueError: If method is not supported.
        TypeError: If data is not array_like.

    Example:
        >>> import numpy as np
        >>> data = np.array([1, 2, 3, 4, 5])
        >>> calculate_statistics(data, method='mean')
        3.0
        >>> calculate_statistics(data, method='std')
        1.4142135623730951

    Note:
        This function uses NumPy internally for calculations.
    """
    import numpy as np

    if not hasattr(data, '__iter__'):
        raise TypeError("Data must be array_like")

    data = np.asarray(data)

    if method == 'mean':
        return np.mean(data, axis=axis)
    elif method == 'median':
        return np.median(data, axis=axis)
    elif method == 'std':
        return np.std(data, axis=axis)
    else:
        raise ValueError(f"Unsupported method: {method}")
```

## 2) NumPy 스타일 Docstring

```python
def process_matrix(matrix, operation='transpose', inplace=False):
    """
    Process a matrix with specified operation.

    Parameters
    ----------
    matrix : array_like
        Input matrix to process.
    operation : {'transpose', 'inverse', 'determinant'}, optional
        Operation to perform on the matrix.
        Default is 'transpose'.
    inplace : bool, optional
        Whether to modify the matrix in-place.
        Default is False.

    Returns
    -------
    ndarray or float
        Processed matrix or scalar value depending on operation.

    Raises
    ------
    ValueError
        If operation is not supported.
    LinAlgError
        If matrix operation fails (e.g., singular matrix for inverse).

    See Also
    --------
    numpy.transpose : Transpose operation
    numpy.linalg.inv : Matrix inverse
    numpy.linalg.det : Matrix determinant

    Examples
    --------
    >>> import numpy as np
    >>> matrix = np.array([[1, 2], [3, 4]])
    >>> process_matrix(matrix, 'transpose')
    array([[1, 3],
           [2, 4]])
    >>> process_matrix(matrix, 'determinant')
    -2.0
    """
    import numpy as np

    matrix = np.asarray(matrix)

    if operation == 'transpose':
        return matrix.T if not inplace else matrix.T
    elif operation == 'inverse':
        return np.linalg.inv(matrix)
    elif operation == 'determinant':
        return np.linalg.det(matrix)
    else:
        raise ValueError(f"Unsupported operation: {operation}")
```

## 3) 클래스 문서화

```python
class DataProcessor:
    """A class for processing various types of data.

    This class provides methods for cleaning, transforming, and analyzing
    different types of data including numerical and text data.

    Attributes:
        data (pandas.DataFrame): The loaded data.
        config (dict): Configuration parameters for processing.

    Example:
        >>> processor = DataProcessor()
        >>> processor.load_data('data.csv')
        >>> cleaned_data = processor.clean_data()
    """

    def __init__(self, config=None):
        """Initialize the DataProcessor.

        Args:
            config (dict, optional): Configuration dictionary.
                If None, uses default configuration.
        """
        self.data = None
        self.config = config or self._default_config()

    def _default_config(self):
        """Return default configuration.

        Returns:
            dict: Default configuration parameters.
        """
        return {
            'remove_duplicates': True,
            'handle_missing': 'drop',
            'normalize': False
        }

    def load_data(self, filepath, **kwargs):
        """Load data from file.

        Args:
            filepath (str): Path to the data file.
            **kwargs: Additional arguments passed to pandas.read_csv.

        Returns:
            pandas.DataFrame: Loaded data.

        Raises:
            FileNotFoundError: If file doesn't exist.
            ValueError: If file format is not supported.
        """
        import pandas as pd
        import os

        if not os.path.exists(filepath):
            raise FileNotFoundError(f"File not found: {filepath}")

        try:
            self.data = pd.read_csv(filepath, **kwargs)
            return self.data
        except Exception as e:
            raise ValueError(f"Failed to load data: {e}")
```

# #05. 문서화 자동화 스크립트

## 1) 배치 문서 생성 스크립트

```python
#!/usr/bin/env python3
"""
Automated documentation generation script.
"""

import os
import subprocess
import argparse
from pathlib import Path

def generate_pdoc_docs(source_dir, output_dir, open_browser=False):
    """Generate documentation using pdoc.

    Args:
        source_dir (str): Source code directory.
        output_dir (str): Output documentation directory.
        open_browser (bool): Whether to open browser after generation.
    """
    cmd = [
        'pdoc',
        '--html',
        '--output-dir', output_dir,
        source_dir
    ]

    if open_browser:
        cmd.append('--browse')

    try:
        subprocess.run(cmd, check=True)
        print(f"Documentation generated successfully in {output_dir}")
    except subprocess.CalledProcessError as e:
        print(f"Error generating documentation: {e}")

def generate_sphinx_docs(source_dir, docs_dir):
    """Generate documentation using Sphinx.

    Args:
        source_dir (str): Source code directory.
        docs_dir (str): Documentation directory.
    """
    # API 문서 자동 생성
    subprocess.run([
        'sphinx-apidoc',
        '-o', docs_dir,
        source_dir,
        '--force'
    ], check=True)

    # HTML 빌드
    os.chdir(docs_dir)
    subprocess.run(['make', 'html'], check=True)
    print(f"Sphinx documentation built in {docs_dir}/_build/html")

def main():
    parser = argparse.ArgumentParser(description='Generate Python API documentation')
    parser.add_argument('source', help='Source code directory')
    parser.add_argument('-o', '--output', default='docs', help='Output directory')
    parser.add_argument('--tool', choices=['pdoc', 'sphinx'], default='pdoc',
                       help='Documentation tool to use')
    parser.add_argument('--browse', action='store_true',
                       help='Open browser after generation (pdoc only)')

    args = parser.parse_args()

    if args.tool == 'pdoc':
        generate_pdoc_docs(args.source, args.output, args.browse)
    elif args.tool == 'sphinx':
        generate_sphinx_docs(args.source, args.output)

if __name__ == '__main__':
    main()
```

## 2) GitHub Actions를 이용한 자동 배포

```yaml
# .github/workflows/docs.yml
name: Generate and Deploy Documentation

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  docs:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pdoc3 sphinx sphinx-rtd-theme
        pip install -r requirements.txt

    - name: Generate documentation
      run: |
        pdoc --html --output-dir docs mypackage

    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/main'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./docs
```

# #06. 문서화 모범 사례

## 1) 좋은 Docstring 작성 원칙

### ✅ 해야 할 것
- 함수의 목적을 명확히 설명
- 모든 매개변수와 반환값 문서화
- 예외 상황 명시
- 사용 예시 제공
- 일관된 스타일 사용

### ❌ 하지 말아야 할 것
- 코드를 단순히 반복하는 설명
- 구현 세부사항에만 집중
- 매개변수 타입 정보 누락
- 모호하거나 불완전한 설명

## 2) 프로젝트 문서 구조

```
project/
├── README.md                 # 프로젝트 개요
├── docs/                     # 문서 디렉토리
│   ├── api/                  # API 레퍼런스
│   ├── tutorials/            # 튜토리얼
│   ├── examples/             # 예제 코드
│   └── changelog.md          # 변경 로그
├── mypackage/               # 소스 코드
│   ├── __init__.py
│   ├── core.py
│   └── utils.py
└── tests/                   # 테스트 코드
```

## 3) 지속적인 문서 관리

```python
# make_docs.py - 문서 생성 스크립트
import subprocess
import sys
from pathlib import Path

def check_docstring_coverage():
    """Check docstring coverage for the project."""
    try:
        result = subprocess.run(['interrogate', '.'],
                              capture_output=True, text=True)
        print("Docstring Coverage Report:")
        print(result.stdout)
    except FileNotFoundError:
        print("Install interrogate: pip install interrogate")

def lint_docstrings():
    """Lint docstrings using pydocstyle."""
    try:
        result = subprocess.run(['pydocstyle', '.'],
                              capture_output=True, text=True)
        if result.stdout:
            print("Docstring Style Issues:")
            print(result.stdout)
        else:
            print("All docstrings follow style guidelines!")
    except FileNotFoundError:
        print("Install pydocstyle: pip install pydocstyle")

if __name__ == '__main__':
    check_docstring_coverage()
    lint_docstrings()
```

이제 Python API 문서 생성에 대한 포괄적인 가이드가 완성되었습니다. 기본적인 pdoc 사용법부터 고급 Sphinx 설정, 자동화 스크립트, CI/CD 연동까지 실무에서 활용할 수 있는 모든 내용을 포함했습니다.