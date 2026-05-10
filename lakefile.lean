import Lake
open Lake DSL

package «bradley-terry» where
  -- add package configuration options here

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «BradleyTerry» where
  -- add library configuration options here
