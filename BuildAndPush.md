# Build & Push — booq-node-red

Instrukcja budowania i publikowania obrazu Docker dla projektu Node-RED.

## Wymagania

- [Docker](https://docs.docker.com/get-docker/) z włączonym **buildx**
- Konto GitHub z dostępem do organizacji `booq-com-pl`
- GitHub Personal Access Token (PAT) z uprawnieniem `write:packages`

### Generowanie PAT

1. Zaloguj się na GitHub
2. Przejdź do **Settings → Developer settings → Personal access tokens → Tokens (classic)**
3. Kliknij **Generate new token**
4. Zaznacz zakres: `write:packages` (automatycznie dodaje też `read:packages`)
5. Skopiuj i zapisz token — będzie potrzebny przy każdym wypchnięciu

## Konfiguracja pakietów Python

Dodaj wymagane pakiety do pliku `requirements.txt` przed zbudowaniem obrazu:

```
requests==2.31.0
pandas==2.1.0
```

Pakiety zostaną zainstalowane w `/opt/venv` wewnątrz obrazu.

## Budowanie i wypychanie obrazu

```bash
./scripts/build-and-push.sh
```

Skrypt wykona kolejno:

1. Zbuduje obraz dla architektury `linux/amd64`
2. Otaguje go jako `booq-node-red` (lokalnie) oraz `ghcr.io/booq-com-pl/node-red:latest`
3. Poprosi o podanie loginu (GitHub username) i hasła (PAT)
4. Zaloguje się do `ghcr.io` i wypchnie obraz
5. Wyloguje się z rejestru

## Obraz w rejestrze

Po wypchnięciu obraz dostępny jest pod adresem:

```
ghcr.io/booq-com-pl/node-red:latest
```

### Użycie obrazu w Kubernetes

Deployment korzysta z obrazu `ghcr.io/booq-com-pl/node-red:latest` oraz secretu `ghcr-secret` do autoryzacji pobierania obrazu z prywatnego rejestru.

#### Tworzenie secretu

Wygeneruj zawartość pliku [k8s/03-secrets.yaml](k8s/03-secrets.yaml) poleceniem:

```bash
kubectl create secret docker-registry ghcr-secret \
  --namespace node-red \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<PAT> \
  --dry-run=client -o yaml
```

Skopiuj wygenerowaną wartość `.dockerconfigjson` i wklej ją do [k8s/03-secrets.yaml](k8s/03-secrets.yaml) w miejscu `<BASE64_ENCODED_DOCKER_CONFIG>`.

Alternatywnie zastosuj secret bezpośrednio na klastrze (bez zapisywania do pliku):

```bash
kubectl create secret docker-registry ghcr-secret \
  --namespace node-red \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<PAT>
```

#### Wdrożenie

```bash
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/03-secrets.yaml
kubectl apply -f k8s/01-deployment.yaml
```

## Struktura plików

```
.
├── Dockerfile            # Definicja obrazu
├── requirements.txt      # Pakiety Python do zainstalowania w venv
├── settings.js           # Konfiguracja Node-RED
├── scripts/
│   └── build-and-push.sh # Skrypt budowania i publikowania
└── k8s/
    ├── 00-namespace.yaml
    ├── 01-deployment.yaml
    └── 03-secrets.yaml
```
