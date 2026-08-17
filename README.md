# US MÍDIA — site institucional

Next.js 15 (App Router) · TypeScript · Tailwind · GSAP + ScrollTrigger

```bash
npm install
npm run dev      # http://localhost:3000
npm run build    # build de produção
npm run typecheck
```

## Estrutura

```
app/
  layout.tsx              loader global + metadados raiz
  page.tsx                portal de entrada (escolha Filmes / IA)
  filmes/page.tsx         área US MÍDIA FILMES
  mid-ia/page.tsx         área US mid.ia
  globals.css             base + tokens de tema
  us-loader.css           estilos do loader

components/
  loader/                 USLoader.tsx + engine.ts
  portal/Portal.tsx       split 50/50 → 65/35 no hover
  backdrops/              fundos animados temporários (canvas)
  site/                   Header, Footer, AreaShell, AreaHero, AreaSwitch
  ui/                     Section, SectionTitle, Prose, Metrics, ModelCards,
                          LogoMarquee, ProcessTimeline, ProjectGrid,
                          MediaPlaceholder, CTAButton, Closing, Reveal

content/                  TODA A COPY E OS DADOS
  site.ts                 WhatsApp, links externos, menu
  filmes.ts               copy da área Filmes
  midia.ts                copy da área US mid.ia
  projects.ts             portfólio das duas áreas

lib/types.ts              tipos + categorias de projeto
lib/gsap.ts               registro do ScrollTrigger
public/us-loader/         SVGs originais da logo
```

## Onde trocar cada coisa

| O quê | Onde |
| --- | --- |
| **Textos da área Filmes** | `content/filmes.ts` |
| **Textos da área IA** | `content/midia.ts` |
| **Número do WhatsApp** | `content/site.ts` → `WHATSAPP_NUMBER` |
| **Mensagens prontas do WhatsApp** | `whatsapp("...")` em cada CTA nos arquivos de content |
| **Links (Academy, redes, e-mail)** | `content/site.ts` → `LINKS` |
| **Itens do menu** | `content/site.ts` → `NAV` |
| **Números dos indicadores (Filmes)** | `content/filmes.ts` → `filmesMetrics` |
| **Números dos indicadores (IA)** | `content/midia.ts` → `midiaMetricsNumeric` + mude `MIDIA_METRICS_MODE` para `"numeric"` |
| **Marcas do carrossel** | `content/filmes.ts` → `filmesBrands` |
| **Projetos do portfólio** | `content/projects.ts` |
| **Categorias de projeto** | `lib/types.ts` |
| **Cores de acento das áreas** | `app/globals.css` → `[data-area="..."]` |
| **Loader (cor, tamanho, ritmo)** | `app/us-loader.css` e `components/loader/engine.ts` |
| **Domínio para SEO** | `app/layout.tsx` → `metadataBase` |

## Mídia — o que ainda é placeholder

Nenhuma imagem ou vídeo real existe no projeto ainda. Todo espaço de mídia
usa `<MediaPlaceholder note="..." />`, que desenha um bloco com a descrição
do que entra ali.

**Para trocar por mídia real**, substitua o componente por:

```tsx
<video
  src="/video/nome.mp4"
  poster="/img/nome.jpg"
  muted
  loop
  playsInline
  preload="none"
/>
```

Sugestão de pastas: `public/video/` e `public/img/`.

Os fundos do portal e dos heros são desenhos em canvas (`components/backdrops/`)
feitos para segurar a apresentação até os vídeos existirem. Para trocar por
vídeo, substitua `<FilmesBackdrop />` / `<MidiaBackdrop />` por um `<video>`
com `poster`, `muted`, `loop` e `playsInline`.

## Placeholders marcados no código

Busque por `[[` para achar todos:

- `content/filmes.ts` → `filmesEncerramento` (a copy de encerramento da área
  Filmes não veio no material)
- `content/projects.ts` → os 6 projetos de exemplo
- `content/site.ts` → número do WhatsApp e links

Os indicadores da US mid.ia estão em **modo conceitual** (`Direção Humana /
Produção Com IA / Entregas Em escala`) justamente para não exibir número
inventado. Troque quando os dados forem confirmados.

## Movimento

Hierarquia usada pelo componente `Reveal`:

| variante | uso | deslocamento |
| --- | --- | --- |
| `text` | textos e componentes | 18px |
| `lines` | títulos, linha a linha | 26px |
| `media` | imagens e vídeos, com máscara | 40px |
| `block` | mudanças de bloco | 64px |

Tudo respeita `prefers-reduced-motion` — com a preferência ativa, o conteúdo
aparece sem animação e o loader roda em versão curta.

## Acessibilidade

- HTML semântico (`header`, `main`, `section`, `article`, `footer`, `dl`).
- Conteúdo renderizado no servidor: nada depende de animação para existir.
- Foco visível com o acento da área.
- Loader com `aria-hidden` e `inert` — não prende o foco do teclado.
- Sem áudio automático (não há vídeo com som).
