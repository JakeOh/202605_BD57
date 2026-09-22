## 1. 권장 구성

| 환경 | 필수 라이브러리 | GPU 사용 |
|---|---|---|
| `torch-env` | numpy, pandas, matplotlib, seaborn, scikit-learn, keras, tensorflow, torch | PyTorch GPU / TensorFlow CPU |
| `tf-env` | 위와 동일 | TensorFlow GPU / PyTorch CPU |

**TensorFlow와 PyTorch를 반드시 분리해야 하는 것은 아닙니다.** 다만 GPU용으로 둘 다 같은 환경에 설치하면 CUDA 관련 의존성이 충돌할 수 있어서, 두 환경으로 나누는 편이 관리하기 쉽습니다.

TensorFlow는 CPU로만 사용해도 된다면 `torch-env` 하나만 만들어도 됩니다.

이하 설명에서는 다음 구조를 사용하겠습니다.

```text
/workspace/
├── miniconda3/
│   └── envs/
│       ├── torch-env/
│       └── tf-env/
├── notebooks/
├── data/
└── outputs/
```

> **주의:** `/workspace`라는 이름만으로 영구 저장이 보장되지는 않습니다. RunPod 설정에서 해당 경로가 Volume Disk 또는 Network Volume에 실제로 연결되어 있는지 확인하세요. 일반적인 Pod용 Volume Disk는 Pod 삭제 시 함께 사라질 수 있습니다.

---

## 2. 설치 전 확인

RunPod의 웹 터미널 또는 JupyterLab 터미널에서 실행합니다.

```bash
uname -m
nvidia-smi
df -h /workspace
```

확인할 내용:

- `uname -m`: CPU 아키텍처
- `nvidia-smi`: GPU 및 드라이버 인식
- `df -h`: 저장 공간

아래 설치 명령은 **`uname -m` 결과가 `x86_64`인 Pod 기준**입니다. `aarch64`라면 ARM용 설치 파일을 사용해야 하며, 이후 딥러닝 패키지 설치도 해당 플랫폼 지원 여부를 확인해야 합니다.

기존 Conda도 확인합니다.

```bash
command -v conda
```

템플릿에 이미 Conda가 있다면 기존 설치를 활용할 수도 있습니다. 다만 기존 설치와 환경이 컨테이너 디스크에 있는지, 영구 저장 볼륨에 있는지는 확인해야 합니다.

---

## 3. Miniconda 설치

### 3-1. 설치 파일 다운로드

```bash
mkdir -p /workspace
cd /workspace

wget -O miniconda.sh \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

`wget`이 없다면 다음 명령을 사용합니다.

```bash
curl -fL \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  -o miniconda.sh
```

보안이 중요한 환경에서는 실행 전 공식 배포 페이지의 SHA-256 체크섬과 다운로드 파일을 비교하세요.

### 3-2. 설치 실행

```bash
bash /workspace/miniconda.sh \
  -b \
  -p /workspace/miniconda3
```

옵션의 의미:

- `-b`: 대화형 질문 없이 설치
- `-p`: 설치 위치 지정

설치가 완료되면 파일을 삭제해도 됩니다.

```bash
rm /workspace/miniconda.sh
```

> `/workspace/miniconda3`에 이미 정상 설치되어 있다면 다시 설치할 필요가 없습니다.

### 3-3. 현재 터미널에서 Conda 활성화

```bash
source /workspace/miniconda3/etc/profile.d/conda.sh

conda --version
```

새 Bash 터미널에서도 자동으로 Conda 명령을 사용하려면 다음을 실행합니다.

```bash
conda init bash
```

이후 터미널을 닫고 다시 열면 됩니다.

기본 `base` 환경이 자동으로 활성화되는 것이 싫다면:

```bash
conda config --set auto_activate_base false
```

**RunPod에서 컨테이너가 새로 만들어지면 홈 디렉터리의 `.bashrc` 설정이 사라질 수 있습니다.** 이때 Miniconda가 영구 볼륨에 남아 있다면 재설치하지 말고 다음 명령으로 다시 불러오세요.

```bash
source /workspace/miniconda3/etc/profile.d/conda.sh
```

---

## 4. PyTorch GPU용 Conda 환경 만들기

### 4-1. Python 환경 생성

호환성을 고려해 Python 3.11을 예시로 사용하겠습니다.

```bash
conda create \
  --prefix /workspace/miniconda3/envs/torch-env \
  python=3.11 pip -y
```

활성화합니다.

```bash
conda activate /workspace/miniconda3/envs/torch-env
```

현재 Python 위치를 확인합니다.

```bash
which python
python --version
```

예상 경로:

```text
/workspace/miniconda3/envs/torch-env/bin/python
```

> Conda 기본 저장소 이용약관 동의 메시지가 표시될 수 있습니다. 표시되는 내용을 확인하고 진행하세요. 조직이나 기업에서 사용한다면 Anaconda 저장소의 이용 조건도 확인하는 것이 좋습니다.

### 4-2. pip 업데이트

```bash
python -m pip install --upgrade pip
```

이번 구성에서는 **Conda는 Python 환경을 관리하고, 프로젝트 패키지는 pip로 설치**합니다. 동일 패키지를 Conda와 pip로 번갈아 설치하거나 업그레이드하는 것은 피하는 편이 좋습니다.

### 4-3. GPU용 PyTorch 설치

PyTorch는 GPU 및 호스트 드라이버에 맞는 빌드를 선택해야 합니다.

다음은 **CUDA 12.6 빌드 설치 예시**입니다.

```bash
python -m pip install torch \
  --index-url https://download.pytorch.org/whl/cu126
```

실제 Pod에서 사용할 명령은 [PyTorch 공식 설치 안내](https://pytorch.org/get-started/locally/)에서 확인하세요. 최신 GPU는 더 새로운 PyTorch/CUDA 빌드가 필요할 수도 있습니다.

**Miniconda를 설치한다고 NVIDIA 드라이버가 설치되는 것은 아닙니다.** RunPod 호스트가 제공하는 드라이버와 선택한 PyTorch 빌드가 호환되어야 합니다.

### 4-4. 나머지 필수 라이브러리 설치

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

`tensorflow-cpu`를 설치해도 코드에서는 동일하게 사용합니다.

```python
import tensorflow as tf
```

이 환경은 다음과 같습니다.

```text
PyTorch       → GPU 사용
TensorFlow    → CPU 사용
Keras         → 기본 TensorFlow 백엔드에서는 CPU 사용
나머지 패키지 → 정상 사용
```

Keras 3는 PyTorch 백엔드로도 설정할 수 있지만, 여기서는 기본적인 TensorFlow 백엔드를 기준으로 설명합니다.

### 4-5. 설치 상태 확인

```bash
python -m pip check
```

GPU도 확인합니다.

```bash
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

마지막 값이 `True`이면 PyTorch에서 GPU를 인식한 상태입니다.

---

## 5. TensorFlow GPU용 Conda 환경 만들기

**TensorFlow/Keras도 GPU로 사용할 때만 추가하면 됩니다.**

### 5-1. 환경 생성 및 활성화

```bash
conda deactivate

conda create \
  --prefix /workspace/miniconda3/envs/tf-env \
  python=3.11 pip -y

conda activate /workspace/miniconda3/envs/tf-env

python -m pip install --upgrade pip
```

### 5-2. CPU용 PyTorch 설치

```bash
python -m pip install torch \
  --index-url https://download.pytorch.org/whl/cpu
```

### 5-3. GPU용 TensorFlow 및 나머지 라이브러리 설치

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

지원되는 Linux 환경에서 `tensorflow[and-cuda]`는 GPU 사용에 필요한 NVIDIA 사용자 공간 라이브러리를 함께 설치합니다.

따라서 처음부터 별도로 다음 패키지들을 Conda로 추가할 필요는 없습니다.

```text
cudatoolkit
cudnn
```

여러 설치 방식으로 CUDA 라이브러리를 중복 구성하면 오히려 문제를 만들 수 있습니다.

### 5-4. 확인

```bash
python -m pip check
```

```bash
python -c \
  "import tensorflow as tf; print(tf.__version__); print(tf.config.list_physical_devices('GPU'))"
```

GPU가 인식되면 다음과 비슷하게 표시됩니다.

```text
[PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]
```

빈 리스트 `[]`가 나오면 드라이버 호환성, 패키지 지원 범위, 템플릿의 CUDA 라이브러리 경로 등을 확인해야 합니다. **Conda 환경은 Python 패키지를 분리하지만, 호스트 드라이버나 모든 시스템 환경변수까지 격리하지는 않습니다.**

---

## 6. JupyterLab에 Conda 환경 등록하기

RunPod 템플릿에 JupyterLab이 이미 실행 중이라면, **각 Conda 환경에 JupyterLab 전체를 설치할 필요는 없습니다.** `ipykernel`을 설치하고 커널을 등록하면 됩니다.

### PyTorch 환경 등록

```bash
conda activate /workspace/miniconda3/envs/torch-env

python -m ipykernel install --user \
  --name runpod-conda-torch \
  --display-name "Python (Conda - PyTorch GPU)"
```

### TensorFlow 환경 등록

```bash
conda activate /workspace/miniconda3/envs/tf-env

python -m ipykernel install --user \
  --name runpod-conda-tf \
  --display-name "Python (Conda - TensorFlow GPU)"
```

JupyterLab 화면을 새로고침하고 커널을 선택하세요.

```text
Python (Conda - PyTorch GPU)
Python (Conda - TensorFlow GPU)
```

등록 명령은 **JupyterLab을 실행하는 사용자와 같은 사용자로 실행**하는 것이 좋습니다. 커널이 보이지 않으면 Jupyter 서버를 재시작해야 할 수도 있습니다.

노트북에서 실제 환경을 확인합니다.

```python
import sys
print(sys.executable)
```

> `--user`로 등록한 커널 정보는 보통 홈 디렉터리에 저장됩니다. 컨테이너가 교체되면서 커널 정보만 사라졌다면, 환경을 다시 설치할 필요 없이 위 등록 명령만 다시 실행하면 됩니다.

---

## 7. 모든 필수 라이브러리 테스트

선택한 Jupyter 커널에서 실행하세요.

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

print("Python:", sys.executable)

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

print("PyTorch GPU:", torch.cuda.is_available())
print("TensorFlow GPUs:", tf.config.list_physical_devices("GPU"))
print("Keras backend:", keras.backend.backend())
```

예상 결과:

| 환경 | 필수 라이브러리 import | PyTorch GPU | TensorFlow GPU |
|---|---|---|---|
| `torch-env` | 모두 성공 | `True` | `[]` |
| `tf-env` | 모두 성공 | `False` | GPU 목록 표시 |

이 구성에서는 한쪽 프레임워크의 GPU가 표시되지 않는 것이 정상입니다.

---

## 8. Pod를 다시 시작했을 때

Conda가 저장된 볼륨이 그대로 연결되어 있고 마운트 경로도 같다면 다음 명령으로 이어서 사용할 수 있습니다.

```bash
source /workspace/miniconda3/etc/profile.d/conda.sh

conda activate /workspace/miniconda3/envs/torch-env

cd /workspace
```

터미널에서 프로그램을 실행하려면:

```bash
python train.py
```

스크립트나 자동화 작업에서는 활성화 없이 Python 경로를 직접 지정해도 됩니다.

```bash
/workspace/miniconda3/envs/torch-env/bin/python \
  /workspace/train.py
```

이 방식은 `.bashrc`나 `conda activate`에 의존하지 않아 편리합니다.

단, 저장된 Conda 환경을 다른 Pod에 연결할 때는 **동일한 CPU 아키텍처와 호환되는 운영체제·드라이버**가 필요합니다. 영구 저장된 환경이 모든 템플릿에서 그대로 작동하는 것은 아닙니다.

---

## 9. 환경 설정 백업

정상 동작을 확인한 뒤 환경 정보를 저장하세요.

```bash
mkdir -p /workspace/env-backups

conda activate /workspace/miniconda3/envs/torch-env

conda env export \
  > /workspace/env-backups/torch-env.yml

python -m pip freeze \
  > /workspace/env-backups/torch-pip.txt
```

TensorFlow 환경도 같은 방식으로 저장할 수 있습니다.

**PyTorch 설치에 사용한 인덱스 URL과 RunPod 템플릿 이미지 태그도 따로 기록하세요.** 환경 내보내기 파일만으로 GPU 환경 전체가 완벽히 재현되는 것은 아닙니다. 중요한 데이터와 모델은 별도 저장소에도 백업하는 것이 안전합니다.

