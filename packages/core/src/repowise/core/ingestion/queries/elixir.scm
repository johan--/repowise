; =============================================================================
; repowise — Elixir symbol and import queries
; tree-sitter-elixir
; =============================================================================

; ---------------------------------------------------------------------------
; Module-like definitions: defmodule, defprotocol, defimpl
; Name is the alias node in arguments (e.g. defmodule Foo.Bar do)
; ---------------------------------------------------------------------------
(call
  target: (identifier) @symbol.modifiers
  (arguments
    (alias) @symbol.name)
  (#match? @symbol.modifiers "^(defmodule|defprotocol|defimpl)$")
) @symbol.def

; ---------------------------------------------------------------------------
; Function/macro definitions with arguments: def foo(x, y), defp bar(z)
; Name is inside a nested call node in arguments
; ---------------------------------------------------------------------------
(call
  target: (identifier) @symbol.modifiers
  (arguments
    (call
      target: (identifier) @symbol.name
      (arguments) @symbol.params))
  (#match? @symbol.modifiers "^(def|defp|defmacro|defmacrop|defguard|defguardp|defdelegate)$")
) @symbol.def

; ---------------------------------------------------------------------------
; Zero-arity functions: def foo do ... end
; Name is a bare identifier in arguments (no nested call)
; ---------------------------------------------------------------------------
(call
  target: (identifier) @symbol.modifiers
  (arguments
    (identifier) @symbol.name)
  (#match? @symbol.modifiers "^(def|defp|defmacro|defmacrop|defguard|defguardp|defdelegate)$")
) @symbol.def

; ---------------------------------------------------------------------------
; Functions with guards: def foo(x) when is_integer(x)
; Arguments contain a binary_operator whose left is a call with the name
; ---------------------------------------------------------------------------
(call
  target: (identifier) @symbol.modifiers
  (arguments
    (binary_operator
      left: (call
        target: (identifier) @symbol.name
        (arguments) @symbol.params)))
  (#match? @symbol.modifiers "^(def|defp|defguard|defguardp)$")
) @symbol.def

; ---------------------------------------------------------------------------
; Imports: use, import, alias, require
; Module is the alias argument
; ---------------------------------------------------------------------------
(call
  target: (identifier) @_import_keyword
  (arguments
    (alias) @import.module)
  (#match? @_import_keyword "^(use|import|alias|require)$")
) @import.statement
