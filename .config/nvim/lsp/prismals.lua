return {
	cmd = { "prisma-language-server", "--stdio" },
	filetypes = { "prisma" },
	root_markers = { "package.json", ".git" },
	settings = {
		prisma = {
			prismaFmtBinPath = "",
		},
	},
}
