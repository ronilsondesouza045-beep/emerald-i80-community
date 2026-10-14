# Publicar o portal

## Vercel

Importe o repositório, defina `site` como Root Directory, escolha o preset `Other` e publique sem comando de build.

## GitHub Pages

Abra Settings → Pages e escolha GitHub Actions. O workflow incluído publicará a pasta `site` a cada alteração na branch `main`.

## O que o site não faz

O portal não hospeda nem encaminha o servidor WoW. A conexão do jogo é fornecida pelo Tailscale e pelo computador anfitrião.
