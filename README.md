# apk/ — Build oficial, baseline e PoC de validação

> Engajamento de segurança **autorizado pelo dono do produto**. Contém o build
> oficial, a baseline de decompilação e o **PoC de validação da chain** (remover
> a barreira de Premium + recompilar), para conferir **no próprio head unit** da
> equipe se o app continua funcional.

## Estrutura

```
apk/
├── README.md                    # este documento
├── original/                    # build oficial (binário limpo, seed)
│   └── jconfig-1.2.3-25.apk     # v1.2.3 (versionCode 25) — 2026-08-19
├── patched/                     # PoC final (versão canônica 1.2.3)
│   └── jconfig-1.2.3-25-premium-fixed.apk   # gate destravado, assinado v1
├── docs/                        # documentação e evidência da versão canônica
│   ├── recon-123.md             # análise + mapa ofuscado 1.2.3
│   ├── rebuild-123.md           # pipeline do PoC corrigido
│   ├── patches/                 # diffs semânticos (evidência)
│   └── tools/                   # Asm.java (assembler) + keystore-poc.jks
└── _descartados/                # versões antigas/intermediárias (lixo arquivável)
```

> ℹ️ **Organização intencional**: o repositório foi consolidado para **uma única
> versão canônica (1.2.3)**. Os builds oficiais 1.2.0 e 1.2.1, os PoCs antigos
> (incompletos/intermediários, incluindo o `-premium-patched` com o gate intacto)
> e os pipelines/recon das versões anteriores foram movidos para `_descartados/`
> para consulta. Nada foi apagado.

## Binários (versão canônica 1.2.3)

| Arquivo | Descrição |
|---------|-----------|
| `original/jconfig-1.2.3-25.apk` | APK oficial 1.2.3 / versionCode 25 (72 249 082 bytes) — SHA-256 `22ec6ecc…` |
| `patched/jconfig-1.2.3-25-premium-fixed.apk` | **PoC corrigido** (72 549 960 bytes), assinado v1 — SHA-256 `f38360de…`. Gate `dw0.a` → sempre `true` |

## PoC 1.2.3 — o que é

- `docs/rebuild-123.md` = pipeline completo do PoC (dex-only):
  - `tp0.smali` → `a()` retorna entitlement **PREMIUM** (`Lso3;->valueOf`)
    com as 9 `PremiumFeature` (`mn2`) no grant set;
  - `o10.smali` → `V()` sem a checagem de binding (`yx3.b == lw.d`);
  - `dw0.smali` → **gate `dw0.a` → sempre `true`** (correção que destrava
    MULTITASKING/GESTURES mesmo em conta free — o patch anterior deixava o
    gate intacto e o cadeado persistia).
- `docs/tools/Asm.java` recompila o `classes.dex` (dex-only);
- `docs/patches/*.diff` = evidência (diferenças vs baseline).
- Validação: `apksigner verify` OK (v1, cert `CN=JConfig PoC`), string
  `jconfig-premium-bypass` presente no dex final.

> Validação no carro: `adb install -r patched/jconfig-1.2.3-25-premium-fixed.apk`
> e conferir **Ajustes → Seu plano = PREMIUM** + sidebar MULTITASKING e GESTURES
> **sem cadeado** + exercitar features.

## Como baixar o build oficial

```bash
curl -L -o original/jconfig-1.2.3-25.apk https://jconfig.app/api/download
```

## Nota de custódia

Keystore de teste: `docs/tools/keystore-poc.jks` (senha `jconfig`) — somente
para este PoC. Artefatos restritos ao engajamento autorizado.