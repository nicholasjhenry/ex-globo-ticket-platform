[
  import_deps: [:phoenix, :assert_html],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,exs}", "{config,lib,test}/**/*.{heex,exs}"],
  heex_line_length: 300
]
