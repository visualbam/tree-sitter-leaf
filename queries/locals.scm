; Scopes
[
  (extend_directive)
  (export_directive)
  (if_directive)
  (unless_directive)
  (for_directive)
  (while_directive)
] @local.scope

; Definitions
(for_directive 
  (identifier) @local.definition.variable)

; References
(identifier) @local.reference
