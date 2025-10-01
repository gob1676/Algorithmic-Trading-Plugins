# Sistema de Plugins

Cada plugin vive en `plugins/<plugin_id>/` y debe incluir `plugin.yml`.

Campos mínimos de `plugin.yml`:

```yaml
name: Nombre legible
id: proveedor.tipo.nombre
version: 0.1.0
type: [indicator|model|broker|dashboard|datasource]
entrypoint: archivo.py
description: Texto
enabled: false
```

El frontend permitirá activar/desactivar plugins más adelante.
