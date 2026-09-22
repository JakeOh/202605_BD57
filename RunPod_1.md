> PyTorch와 TensorFlow 두 프레임워크는 요구하는 CUDA/cuDNN 버전이 달라 한 Python 환경에 GPU 버전을 함께 설치하면 충돌할 수 있습니다. 따라서 아래처럼 구성하는 것을 추천합니다.
>
> - **PyTorch용 환경**: 모든 필수 라이브러리 사용 가능. PyTorch는 GPU, TensorFlow는 CPU 사용.
> - **TensorFlow용 환경**: 모든 필수 라이브러리 사용 가능. TensorFlow/Keras는 GPU, PyTorch는 CPU 사용.
>
> 같은 Pod 안에 두 환경을 만들고, JupyterLab에서 커널만 바꿔 사용하면 됩니다. PyTorch와 TensorFlow를 모두 GPU로 활용하면서도 설치 충돌을 크게 줄일 수 있습니다.

---

# 1. RunPod에서 알아야 할 기본 개념

| 항목 | 의미 |
|---|---|
| Pod | GPU·CPU·메모리 등이 할당된 작업 환경 |
| Template | 운영체제, Python, CUDA, Jupyter 등의 초기 구성이 담긴 컨테이너 이미지 |
| GPU VRAM | GPU 메모리. 실행할 수 있는 모델 크기와 배치 크기에 영향 |
| Container Disk | 컨테이너의 기본 파일시스템. 영구 보관 장소로 생각하지 않는 것이 안전 |
| Volume Disk | Pod에 연결된 저장 공간. 일반적인 구성에서는 `/workspace`에 마운트 |
| Network Volume | Pod와 별도로 관리할 수 있는 영구 저장 공간. 사용 가능한 지역 등에 제약 |
| JupyterLab | 브라우저에서 노트북, 터미널, 파일을 사용하는 개발 도구 |

RunPod는 메뉴 이름, 제공 템플릿, 요금 정책 등이 바뀔 수 있으므로 실제 생성 화면에서 표시되는 조건을 확인해야 합니다.

특히 다음 두 가지를 기억하세요.

- **GPU 비용과 저장 공간 비용은 별개**입니다.
- **작업 파일과 Python 환경은 영구 저장 볼륨에 저장**해야 합니다.

---

# 2. 어떤 GPU를 선택하면 좋을까?

일반적인 데이터 분석과 딥러닝 입문 기준입니다.

| 작업 | 권장 사항 |
|---|---|
| pandas, matplotlib, seaborn 중심 분석 | GPU가 거의 필요하지 않음 |
| 일반적인 scikit-learn 학습 | 대부분 CPU 사용. CPU·RAM도 중요 |
| 작은 딥러닝 모델 학습 | 16~24GB VRAM급부터 검토 |
| 이미지 모델, 비교적 큰 배치 학습 | 24~48GB VRAM급 검토 |
| 대형 모델 학습·추론 | 모델 크기에 따라 48GB, 80GB 이상 검토 |

처음 시작한다면 다음 정도가 무난합니다.

```text
GPU: RTX 3090 / RTX 4090 / A5000 등 24GB급
GPU 개수: 1개
시스템 RAM: 32GB 이상이면 편리
Container Disk: 20~30GB 이상
작업용 영구 저장 공간: 100GB 이상 권장
Python: 3.11 권장
```

두 개의 딥러닝 환경과 데이터셋을 함께 저장하면 공간이 생각보다 많이 필요합니다. 데이터가 크다면 저장 공간을 더 확보하세요.

> GPU 성능만 보고 선택하지 말고 CPU 코어 수, 시스템 RAM, 저장 공간, 시간당 가격도 함께 확인하세요.

---

# 3. Pod 생성하기

## 3-1. 가입 및 결제 설정

1. RunPod에 가입하고 로그인합니다.
2. 결제 수단을 등록하거나 사용할 크레딧을 충전합니다.
3. 콘솔에서 **Pods** 또는 GPU Pod 생성 메뉴로 이동합니다.

지속적으로 접속해 개발할 목적이라면 일반적으로 **Pods**가 적합합니다. 요청이 들어올 때만 추론하는 API 서비스가 목적일 때는 Serverless를 따로 검토하면 됩니다.

## 3-2. GPU와 요금 방식 선택

처음에는 **On-Demand** 방식이 이해하기 쉽습니다.

Spot 또는 중단 가능한 인스턴스를 선택할 경우 비용을 줄일 수 있지만, 작업 도중 종료될 가능성에 대비해야 합니다.

장시간 학습에서는 어느 방식이든 모델 체크포인트를 주기적으로 저장하는 것이 좋습니다.

## 3-3. Template 선택

다음 조건을 갖춘 템플릿을 선택하세요.

- RunPod 제공 PyTorch 또는 CUDA 기반 개발 템플릿
- JupyterLab 지원
- NVIDIA GPU 사용 지원
- 가능하면 Python 3.11
- SSH 지원은 선택 사항

**PyTorch 템플릿을 고르더라도 TensorFlow 환경을 별도로 만들 수 있습니다.**

템플릿에 포함된 라이브러리를 그대로 수정하는 것보다는, 아래에서 설명할 별도 가상환경을 만드는 편이 관리하기 쉽습니다.

## 3-4. 저장 공간 설정

가능하면 다음과 같이 설정합니다.

```text
Container Disk: 30GB
Volume Disk 또는 Network Volume: 100GB 이상
작업 볼륨 마운트 경로: /workspace
```

단, `/workspace`라는 디렉터리 이름 자체가 영구 저장을 보장하는 것은 아닙니다. **해당 경로가 실제 볼륨에 연결되어 있는지** Pod 설정에서 확인하세요.

- Pod를 잠깐 멈췄다가 이어서 사용할 목적이라면 Volume Disk가 편리할 수 있습니다.
- Pod를 삭제하거나 바꾸더라도 데이터를 보존하려면 Network Volume이 더 적합할 수 있습니다.
- Network Volume은 GPU를 선택할 수 있는 데이터센터 등에 영향을 줄 수 있습니다.

## 3-5. 네트워크 및 접속 설정

JupyterLab 템플릿에서는 보통 `8888` 포트가 설정되어 있습니다.

직접 설정하는 템플릿이라면 필요에 따라 다음 포트를 사용합니다.

```text
8888: JupyterLab
22: SSH
```

포트만 열어서는 접속되지 않고, 해당 포트에서 프로그램이 실행 중이어야 합니다.

**Jupyter 인증 토큰이나 비밀번호를 제거한 상태로 인터넷에 공개하지 마세요.**

설정을 확인한 뒤 Pod를 생성하고 준비가 끝날 때까지 기다립니다.

---

# 4. Pod에 접속하고 GPU 확인하기

Pod의 **Connect** 메뉴에서 JupyterLab 또는 웹 터미널로 접속합니다.

터미널에서 다음을 실행하세요.

```bash
nvidia-smi
```

다음 정보가 나타나면 GPU 드라이버가 보이는 상태입니다.

- GPU 모델
- Driver Version
- GPU 메모리 사용량
- 실행 중인 GPU 프로세스

Python도 확인합니다.

```bash
python3 --version
```

아래 설치 예시는 **Python 3.11을 기준으로 권장**합니다. 최신 Python 버전은 일부 딥러닝 패키지의 지원이 늦을 수 있습니다.

> `nvidia-smi`의 `CUDA Version`은 드라이버가 지원하는 CUDA 수준을 나타냅니다. 현재 Python 환경에 설치된 CUDA 런타임 버전과 반드시 같지는 않습니다.

---

# 5. 필수 라이브러리 환경 구성

최종 구조는 다음과 같습니다.

```text
/workspace/
├── venvs/
│   ├── torch/       # PyTorch GPU + TensorFlow CPU
│   └── tf/          # TensorFlow GPU + PyTorch CPU
├── notebooks/
├── data/
├── outputs/
└── requirements/
```

디렉터리를 만듭니다.

```bash
mkdir -p /workspace/{venvs,notebooks,data,outputs,requirements}
```

아래 명령의 `python3`가 원하는 Python 버전인지 먼저 확인하세요. Python 3.11이 별도로 설치되어 있다면 `python3.11`로 바꿔 실행해도 됩니다.

---

## 5-1. PyTorch GPU 환경 만들기

### ① 가상환경 생성

```bash
python3 -m venv /workspace/venvs/torch

source /workspace/venvs/torch/bin/activate

python -m pip install --upgrade pip setuptools wheel
```

만약 `venv` 관련 오류가 발생하면 템플릿에 해당 Python 버전의 `venv` 패키지가 없는 경우입니다. Ubuntu 계열에서는 적절한 `python3-venv` 또는 `python3.11-venv` 패키지를 설치해야 할 수 있습니다.

### ② GPU용 PyTorch 설치

아래는 **CUDA 12.6 휠을 사용하는 예시**입니다.

```bash
python -m pip install torch \
  --index-url https://download.pytorch.org/whl/cu126
```

**이 명령을 모든 Pod에서 무조건 사용할 수 있는 것은 아닙니다.**

선택한 GPU와 호스트 드라이버에 맞는 명령을 [PyTorch 공식 설치 페이지](https://pytorch.org/get-started/locally/)에서 확인하는 것이 가장 정확합니다. CUDA 12.6 환경에는 충분히 최신 드라이버가 권장됩니다.

호스트 NVIDIA 드라이버는 보통 Pod 안에서 임의로 업데이트하는 대상이 아닙니다. 드라이버가 맞지 않으면 지원되는 PyTorch 빌드를 선택하거나 다른 호스트의 Pod를 사용하세요.

### ③ 나머지 필수 패키지 설치

```bash
python -m pip install \
  numpy \
  pandas \
  matplotlib \
  seaborn \
  scikit-learn \
  keras \
  tensorflow-cpu \
  ipykernel
```

여기서 중요한 점은 다음과 같습니다.

- `tensorflow-cpu`를 설치해도 Python에서는 `import tensorflow`로 사용합니다.
- 이 환경에서는 TensorFlow GPU 사용이 목적이 아닙니다.
- `scikit-learn`의 import 이름은 `sklearn`입니다.

### ④ 패키지 의존성 검사

```bash
python -m pip check
```

정상이라면 다음과 비슷하게 표시됩니다.

```text
No broken requirements found.
```

단, 이 검사는 Python 패키지 의존성 검사입니다. GPU가 실제로 동작하는지는 별도로 확인해야 합니다.

### ⑤ Jupyter 커널 등록

```bash
python -m ipykernel install --user \
  --name runpod-torch \
  --display-name "Python (PyTorch GPU)"
```

설치 버전을 저장합니다.

```bash
python -m pip freeze \
  > /workspace/requirements/torch-freeze.txt
```

---

## 5-2. TensorFlow GPU 환경 만들기

TensorFlow도 GPU로 사용하려면 이 환경까지 구성합니다.

### ① 가상환경 생성

```bash
deactivate

python3 -m venv /workspace/venvs/tf

source /workspace/venvs/tf/bin/activate

python -m pip install --upgrade pip setuptools wheel
```

### ② CPU용 PyTorch 설치

```bash
python -m pip install torch \
  --index-url https://download.pytorch.org/whl/cpu
```

이 환경에서도 `import torch`와 CPU 연산이 가능합니다.

### ③ GPU용 TensorFlow와 나머지 라이브러리 설치

```bash
python -m pip install \
  "tensorflow[and-cuda]" \
  keras \
  numpy \
  pandas \
  matplotlib \
  seaborn \
  scikit-learn \
  ipykernel
```

지원되는 Linux 환경에서 `tensorflow[and-cuda]`는 TensorFlow의 GPU 실행에 필요한 NVIDIA 사용자 공간 라이브러리도 함께 설치하는 방식입니다.

다만 다음 조건은 여전히 필요합니다.

- 선택한 TensorFlow 버전이 Python 버전을 지원해야 함
- GPU 아키텍처를 지원해야 함
- 호스트 드라이버가 해당 CUDA 런타임을 지원해야 함

가상환경을 나누더라도 템플릿의 `LD_LIBRARY_PATH` 같은 시스템 설정에 의해 CUDA 라이브러리가 간섭할 수 있습니다. GPU 인식 문제가 생기면 템플릿의 CUDA 설정도 함께 확인해야 합니다.

### ④ 검사 및 커널 등록

```bash
python -m pip check

python -m ipykernel install --user \
  --name runpod-tf \
  --display-name "Python (TensorFlow GPU)"

python -m pip freeze \
  > /workspace/requirements/tf-freeze.txt
```

> 위 명령은 특정 버전을 고정하지 않고 설치 시점의 호환 가능한 패키지를 설치합니다. 정상 동작을 확인한 후에는 버전 목록, 사용한 템플릿 이미지 태그, PyTorch 설치 인덱스 주소를 함께 기록해 두세요. `pip freeze`만으로 GPU 환경 전체가 완전히 재현되는 것은 아닙니다.

---

# 6. JupyterLab에서 환경 선택하기

JupyterLab 화면을 새로고침한 뒤 노트북을 만들면 다음 커널이 보입니다.

```text
Python (PyTorch GPU)
Python (TensorFlow GPU)
```

기존 노트북에서는 메뉴의 **Kernel → Change Kernel** 등으로 변경할 수 있습니다.

현재 어떤 환경인지 확인하려면 다음을 실행하세요.

```python
import sys
print(sys.executable)
```

PyTorch 환경이라면 다음 경로가 나와야 합니다.

```text
/workspace/venvs/torch/bin/python
```

TensorFlow 환경이라면:

```text
/workspace/venvs/tf/bin/python
```

**설치했는데 `ModuleNotFoundError`가 나는 가장 흔한 원인은 설치한 환경과 노트북 커널이 다른 것입니다.**

노트북에서 패키지를 추가로 설치해야 한다면 보통 다음 방식이 안전합니다.

```python
%pip install 패키지이름
```

설치 후에는 커널을 재시작해야 할 수 있습니다.

---

# 7. 필수 라이브러리 전체 확인

각 커널에서 다음 코드를 실행하세요.

```python
import sys
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import sklearn
import keras
import tensorflow as tf
import torch

print("Python:", sys.version)
print("Executable:", sys.executable)
print()

packages = {
    "numpy": np,
    "pandas": pd,
    "matplotlib": matplotlib,
    "seaborn": sns,
    "scikit-learn": sklearn,
    "keras": keras,
    "tensorflow": tf,
    "torch": torch,
}

for name, module in packages.items():
    print(f"{name}: {module.__version__}")

print()
print("PyTorch GPU:", torch.cuda.is_available())
print("TensorFlow GPUs:", tf.config.list_physical_devices("GPU"))
print("Keras backend:", keras.backend.backend())
```

이 구성에서 예상되는 결과는 다음과 같습니다.

| 커널 | 모든 필수 import | PyTorch GPU | TensorFlow GPU |
|---|---:|---:|---:|
|
