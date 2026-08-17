# US MÍDIA — como subir

## Rodar local

```bash
npm install
npm run dev        # http://localhost:3000
```

O `node_modules` **não** vem no pacote, de propósito: ele carrega binários
compilados para o sistema onde foi instalado. Rode `npm install` na sua
máquina e no servidor.

## Build de produção

```bash
npm run build
npm start
```

## Versões — leia antes de mexer

| pacote | versão | por quê essa |
| --- | --- | --- |
| next | `15.5.22` | linha `backport` do Next: é a que segue recebendo correção de segurança sem virar major |
| react / react-dom | `19.2.8` | último estável da 19 |

Essas versões estão **fixas, sem `^`**, e existe um `package-lock.json` no
projeto. Não é preciosismo: em dezembro de 2025 saiu a CVE-2025-55182
(execução remota de código pelo protocolo de Server Functions do React) e a
Netlify passou a **bloquear deploys** de qualquer projeto rodando versão
afetada. O primeiro deploy deste site travou exatamente nisso, porque o
`package.json` estava preso no Next 15.1.6.

Duas consequências práticas:

- **não volte versão** de `next`, `react` ou `react-dom` sem checar
  `npm audit`. Se aparecer `critical`, a Netlify recusa o deploy;
- **mantenha o `package-lock.json` versionado**. Sem ele o build na nuvem
  resolve as dependências por conta própria e pode não instalar o que foi
  testado aqui.

Para atualizar com segurança mais para frente:

```bash
npm install next@backport react@latest react-dom@latest
npm audit          # não pode sobrar 'critical'
npm run typecheck
npm run build
```

O que continua aparecendo como `high` no `npm audit` é `postcss` e `sharp`,
ambos dependências internas do Next e usados só em tempo de build. O npm só
oferece conserto pulando para o Next 16 (major). Isso não bloqueia deploy e
não vale o risco de migração agora.

## Deploy na Netlify

Já existe `netlify.toml` na raiz. O comando de build é `npm ci && npm run
build`, o `publish` é `.next` e o Node está fixado em 22 (também no `.nvmrc`).

1. suba a pasta num repositório Git
2. importe o repositório na Netlify
3. deixe a Netlify instalar sozinha o `@netlify/plugin-nextjs` — não fixe a
   versão do plugin, é por ele que chegam as correções do adaptador
4. não precisa de variável de ambiente nem banco

⚠️ O `.gitignore` já exclui `MIDIAS/`, `LOADER/`, `LOGOS/` e
`LOGOS CLIENTES/`. São os arquivos de origem, vários gigabytes — se forem
para o repositório, o push trava e o build estoura. O que o site usa já está
transcodificado em `public/media`.

## Deploy na Vercel

Mesma coisa, sem configurar nada: a Vercel detecta Next.js 15 com App Router
e usa o `package.json`. As três rotas (`/`, `/filmes`, `/mid-ia`) são
estáticas.

## Antes de publicar

| pendência | onde |
| --- | --- |
| domínio real para SEO | `app/layout.tsx` → `metadataBase` |
| número do WhatsApp | `content/site.ts` → `WHATSAPP_NUMBER` |
| links de Academy, redes e e-mail | `content/site.ts` → `LINKS` |
| copy de encerramento da Filmes | `content/filmes.ts` → `filmesEncerramento` (está com `[[...]]`) |
| números da mid.ia | `content/midia.ts` → `midiaMetricsNumeric` + mudar `MIDIA_METRICS_MODE` |
| nomes de clientes e de projetos | `content/clients.ts` e `content/gallery.ts` — saíram dos nomes dos arquivos |
| licença web da fonte | `public/fonts/` — autohospedar expõe o arquivo publicamente |

## Onde ajustar cada coisa

| o quê | onde |
| --- | --- |
| textos das duas áreas | `content/filmes.ts` e `content/midia.ts` |
| cores das vertentes | `app/globals.css` → `[data-area="..."]` |
| loader (cor, tamanho, ritmo) | `app/us-loader.css` e `components/loader/engine.ts` |
| transição portal → menu | `lib/iconFlight.ts` |
| carrossel 3D (arco, ritmo) | `components/ui/Carousel3D.tsx` |
| faixa que expande e o modo mobile | `components/ui/ExpandOnHover.tsx` |
| pilha dos modelos de atuação | `components/ui/StackedModels.tsx` |
| fundo dot matrix dos indicadores | `components/ui/Metrics.tsx` |
| carrossel de logos de cliente | `components/ui/LogoMarquee.tsx` |

## Peso

Cerca de 15 MB, quase tudo em `public/media` — 32 clipes de vídeo com poster.
Os masters originais, 4,9 GB, ficaram de fora: só as versões web entraram.
