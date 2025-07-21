return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{
				"tpope/vim-dadbod",
				lazy = true,
				-- this is specific to BigQuery, since the default
				-- for `bq` is legacy SQL for whatever reason.
				-- (almost always want to use standard SQL)
				-- Also, in dadbod-ui aggregated results will not
				-- disply w/ format=pretty (make PR?)
				config = function()
					local home = vim.fn.expand("$HOME")
					local rc_path = home .. "/.bigqueryrc"

					local f = io.open(rc_path, "r")
					if f then
						f:close()
						return
					end

					local out = io.open(rc_path, "w")
					if out then
						out:write("--format=sparce\n\n[query]\n--use_legacy_sql=false\n")
						out:close()
						vim.notify("Created ~/.bigqueryrc w/ legacy SQL set to false.", vim.log.levels.INFO)
					else
						vim.notify("Failed to write ~/.bigqueryrc", vim.log.levels.ERROR)
					end
				end,
			},
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
}
