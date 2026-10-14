// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!
//

// =============== MODE COLORS ===============

// Glide sets `--glide-current-mode-color` to `--glide-mode-<mode>`. Painting the
// toolbox with it (what a theme's `frame` color does) keeps the system light/dark
// theme instead of replacing it with a light custom theme.
browser.theme.reset();

glide.styles.add(css`
  :root {
    --glide-mode-normal: light-dark(#f2f3f4, #2b2a33);
    --glide-mode-insert: light-dark(#d8b9e7, #4a3a57);
    --glide-mode-command: light-dark(#b9c8e7, #34405a);
    --glide-mode-hint: light-dark(#fffacd, #4d4a2e);
    --glide-mode-visual: var(--glide-mode-normal);
    --glide-mode-op-pending: var(--glide-mode-normal);
    --glide-mode-ignore: var(--glide-mode-normal);

    --toolbox-background-color: var(--glide-current-mode-color) !important;
    --toolbox-background-color-inactive: var(--glide-current-mode-color) !important;
  }
`, { id: "mode-colors", overwrite: true });

// Firefox reports the previously active tab, or undefined if it was closed.
let previousTabId: number | undefined;

browser.tabs.onActivated.addListener((info) => {
	previousTabId = info.previousTabId;
});

// =============== KEYMAPS ===============

glide.keymaps.set(
	"normal",
	"<Space><Tab>",
	() => glide.excmds.execute("tab_next"),
	{ description: "leader + tab to cycle tabs" },
);

glide.keymaps.set(["normal", "insert"], "<C-n>", () => glide.excmds.execute("tab_next"), {
	description: "crl + n to cycle tabs",
});

glide.keymaps.set("normal", "<Space>t", () => glide.excmds.execute("commandline_show tab "), {
	description: "tab picker",
});


// =============== TABS ===============

glide.keymaps.set(
	"normal",
	"<Space><Space>",
	async () => {
		if (previousTabId !== undefined) {
			// The tab may have been closed since it was last active.
			await browser.tabs.update(previousTabId, { active: true }).catch(() => {});
		}
	},
	{
		description: "switch to latest tab",
	},
);

glide.keymaps.set("normal","me",
  async () => {
    const [tab] = await browser.tabs.query({ active: true, currentWindow: true });
    if (tab?.id) {
      await browser.tabs.move(tab.id, { index: -1 });
    }
  },
  { description: "[m]ove tab to [e]nd" },
);

// =============== Sites ===============

glide.autocmds.create("UrlEnter", {
  hostname: "www.youtube.com",
}, async () => {
  glide.buf.keymaps.del("normal", "<Space>");
  glide.buf.keymaps.del("normal", "j");
  glide.buf.keymaps.del("normal", "k");
  glide.buf.keymaps.del("normal", "f");
});


// =============== Looks ===============

glide.styles.add(css`
  /* Move close button from left to right on vertical tabs  and smaller */
  #tabbrowser-tabs[orient="vertical"] .tab-close-button {
    inset-inline-start: unset !important;
    inset-inline-end: 2px !important;
    width: 10px !important;
    height: 10px !important;
  }

  /* Larger favicon with less padding on vertical tabs */
  #tabbrowser-tabs[orient="vertical"] .tab-icon-image {
    width: 20px !important;
    height: 20px !important;
  }

  #tabbrowser-tabs[orient="vertical"] .tab-icon-stack {
    min-width: 20px !important;
    min-height: 20px !important;
  }

  /* Move playing icon out of the way*/
  #tab-icon-overlay {
    inset-inline-end: -18px !important;
    top: 13px !important;
  }
`, { id: "custom-tab-styles", overwrite: true });

// =============== Tab Jump ===============

const TAB_KEYS = "asdfghjklqwertyuiopzxcvbnm";

// Hint the real tab strip (the config's `document` is a best-effort mirror whose
// tab order can drift after pinning/grouping) and resolve the picked element to
// its tab by its position among all tabs, which is the WebExtension `tab.index`.
glide.keymaps.set("normal", "gt", () => glide.hints.show({
  location: "browser-ui",
  selector: "tab.tabbrowser-tab:not([hidden])",
  // Last visible tab gets 'a', second-to-last gets 's', etc.
  label_generator: (ctx) => ctx.hints.length <= TAB_KEYS.length
    ? ctx.hints.map((_, i) => TAB_KEYS[ctx.hints.length - 1 - i])
    : glide.hints.label_generators.prefix_free(ctx),
  action: async ({ content }) => {
    const index = await content.execute((el) =>
      [...el.ownerDocument.querySelectorAll("tab.tabbrowser-tab")].indexOf(el));
    const tab = await glide.tabs.get_first({ currentWindow: true, index });
    if (tab?.id) {
      await browser.tabs.update(tab.id, { active: true });
    }
  },
}), {
  description: "[g]o to [t]ab by letter",
});


glide.prefs.set("browser.sessionstore.interval", 60000);
