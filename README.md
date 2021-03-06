# NLP with PyTorch 고급반 실습용 도커 이미지

* OS: Ubuntu 16.04
* Preinstalled libraries: PyTorch (CPU), TorchText, KoNLPy, Mecab-Ko, MUSE, Champollion, FastText, NLTK, SRILM
* Sample code in `/root`
* External library source code in `/opt`
* SSH enabled(requires port publish)
* Dockerfile available at https://github.com/juneoh/fastcampus-pytorchnlp-advanced

## Docker Quickstart

`sudo` 권한이 필요할 수 있습니다.

### 이미지 불러오기

```
docker load -i 이미지파일
```

예: `docker load -i pytorchnlp-advanced.v0.3.0.img.tar`

### 새 컨테이너 띄우기

```
docker run 옵션 이미지명
```

예: `docker run -d -P --name nlp pytorchnlp-advanced:v0.3.0`

* `-d` 데몬 모드
* `-P` 컨테이너 포트와 호스트 포트 연결
* `--name` 컨테이너명 지정

### 실행 중인 컨테이너 셸에 접속하기

```
docker exec -it 컨테이너명 명령어
```

* `-t` 가상 터미널 생성
* `-i` STDOUT/STDIN 연결

예: `docker exec -it nlp bash`

### 컨테이너 중지하기

```
docker stop 컨테이너명
```

예: `docker stop nlp`

### 컨테이너 재실행하기

```
docker start 컨테이너명
```

예: `docker start nlp`

### 컨테이너에 파일 복사하기

```
docker cp 파일명 컨테이너명:위치
```

예: `docker cp data.txt nlp:/root/`

### 연결된 포트 번호 확인하기

```
docker port 컨테이너명 컨테이너포트번호
```

예: `docker port nlp 22`

### SSH 접속하기

```
ssh root@localhost -p 포트번호 -o PasswordAuthentication=yes
```
