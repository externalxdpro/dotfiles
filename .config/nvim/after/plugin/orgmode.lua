local status_ok, orgmode = pcall(require, "orgmode")
if not status_ok then
	return
end

orgmode.setup({
	org_agenda_files = "~/Notes/agenda.org",
	-- org_default_notes_file = "",
})

orgmode.setup_ts_grammar()
