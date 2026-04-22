# Handmade Bytes

A technical blog built with mdBook, focused on systems, software, and engineering ideas.

The site is compiled into a static book and deployed via GitHub Pages.

---

## Structure

- `src/` — blog content (chapters, posts)
- `book.toml` — mdBook configuration
- `justfile` — development and build commands
- `STYLEGUIDE.md` — writing standards (authoritative reference)

## Prerequisites
You will need NVM installed to install and select the right version of Node.

## Development
If running the project in trusted mode in VSCode then all you will need to do is run `npm run dev` via the command line as the prerequisites will have automatically been satisfied. If not, to run the project simply run this composite command `nvm install && nvm use && npm install && npm run dev`.