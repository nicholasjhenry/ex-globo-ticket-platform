[
  import_deps: [:phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,exs}", "{config,lib,test}/**/*.{heex,exs}"],
  heex_line_length: 300
]
