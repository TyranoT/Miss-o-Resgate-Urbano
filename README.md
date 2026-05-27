# Miss-o-Resgate-Urbano

Base Flutter para o desafio "SOS Cidade", com Provider, SQLite e fluxo de dashboard + cadastro de chamados.

## Estrutura

- `lib/main.dart`: inicializa o banco e sobe o Provider.
- `lib/app.dart`: configura o `MaterialApp`.
- `lib/models/chamado.dart`: modelo e enums do domínio.
- `lib/data/chamado_database.dart`: persistência SQLite.
- `lib/providers/chamado_provider.dart`: estado, regras de negócio e ordenação.
- `lib/screens/dashboard_page.dart`: dashboard com cards, alerta e lista.
- `lib/screens/chamado_form_page.dart`: cadastro e edição de chamados.
- `lib/screens/home_shell.dart`: navegação principal.

## Como começar

1. Instale o Flutter SDK.
2. Rode `flutter pub get` na raiz do projeto.
3. Execute `flutter run` em um dispositivo ou emulador disponível.

## Regras já cobertas

- Chamados com prioridade alta ou crítica aparecem no topo.
- Alerta visual quando houver mais de 5 chamados críticos.
- Título repetido não é permitido.
- Descrição vazia e bairro vazio são bloqueados.
- Chamados concluídos ficam travados para edição.
- O tempo desde a abertura é calculado na lista.