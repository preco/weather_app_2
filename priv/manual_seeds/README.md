Manual seeds
=============

Arquivos SQL nesta pasta são destinados a execução MANUAL somente.

- Não coloque arquivos aqui se você espera que `priv/repo/seeds.exs` ou outro
  processo de seeding os execute automaticamente.
- Para popular o banco com este arquivo, execute manualmente (exemplo):

```bash
psql -d YOUR_DATABASE -f priv/manual_seeds/measurements_seed.sql
```

ou via container:

```bash
docker exec -i <container> psql -U <user> -d <db> -f - < priv/manual_seeds/measurements_seed.sql
```

Este arquivo foi movido de `priv/repo/seeds/measurements_seed.sql` para evitar
execução acidental por `mix ecto.reset` ou `mix run priv/repo/seeds.exs`.