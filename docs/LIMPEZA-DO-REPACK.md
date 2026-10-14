# Limpeza segura do repack

O repack original inspecionado contém aproximadamente 3,28 GB e 20.714 arquivos. A maior parte é necessária para o WorldServer, especialmente `Data/` e os bancos MySQL.

## Pode ser removido de uma cópia de distribuição

- `_BACKUP_ANTES_NPC/` e outras pastas `_BACKUP_*`, depois de guardar uma cópia privada;
- `Logs/` e arquivos `*.log`;
- arquivos `mysql-bin.*` antigos somente após desligar corretamente o MySQL e confirmar uma estratégia de backup;
- `_Server/mysql/bin/debug/` e arquivos `*.pdb`, caso não sejam usados para depuração;
- utilitários de teste do MySQL, se a distribuição for cuidadosamente testada depois;
- arquivos temporários e PID obsoletos.

## Não remover

- `Data/dbc`, `Data/maps`, `Data/vmaps` e `Data/mmaps`;
- `_Server/mysql/data/world`, `auth` e `characters` da instalação privada;
- `authserver.exe`, `worldserver.exe` e suas DLLs;
- `authserver.conf`, `worldserver.conf` e scripts Lua usados pelo servidor;
- o patch do cliente exigido pelas customizações.

## Não publicar

- bancos reais de `auth` e `characters`;
- contas, hashes de senha, personagens ou IPs de jogadores;
- senhas do MySQL;
- links privados de compartilhamento Tailscale;
- executáveis, dados ou recursos de terceiros sem licença de redistribuição.

Por segurança, nenhuma exclusão automática é feita no repack original. Monte a distribuição em uma cópia separada e teste login, seleção do realm, criação de personagem e entrada no mundo antes de entregá-la.
