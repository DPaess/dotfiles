-- LaTeX: compilacao continua + preview com SyncTeX bidirecional.
-- Equivalente local ao Overleaf para os TCCs em ~/Documents/TCC.
--
-- Atalhos (localleader = <space>, igual ao leader):
--   <space>ll  liga/desliga a compilacao continua (recompila a cada :w)
--   <space>lv  abre o PDF na pagina do cursor (forward search)
--   <space>lk  mata a compilacao
--   <space>lc  limpa os artefatos de build
--   <space>le  abre a lista de erros
--   <space>lt  indice do documento
-- No Zathura, Ctrl+clique volta para a linha do .tex (inverse search).
--
-- Requer: latexmk, pdflatex, bibtex (texlive-*) e zathura + zathura-pdf-poppler.

return {
  "lervag/vimtex",
  lazy = false, -- vimtex nao deve ser lazy-loaded por ft; ele se registra sozinho
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"

    -- Nao roubar o foco com a quickfix a cada recompilacao.
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- Avisos ruidosos e irrelevantes para este modelo.
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull \\\\hbox",
      "Overfull \\\\hbox",
      "Package hyperref Warning",
      "Token not allowed in a PDF string",
    }

    -- Encontra a raiz do projeto pelo .latexmkrc que cada TCC tem, de modo que
    -- abrir Eletronica/cap/2-fundamentacao.tex compila Eletronica/main.tex, e
    -- Controle/cap/*.tex compila Controle/main.tex, sem confusao entre os dois.
    vim.g.vimtex_root_resolver_exclude = {}
    vim.g.tex_flavor = "latex"

    -- O .latexmkrc de cada pasta ja define pdf_mode, bibtex e synctex.
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "",
      out_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Conceal desligado: o texto tecnico tem muito $V_{GS}$ e \textit{}, e
    -- esconder a marcacao atrapalha mais do que ajuda ao revisar.
    vim.g.vimtex_syntax_conceal_disable = 1
  end,
}
