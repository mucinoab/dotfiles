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

// =============== AUTOCMDS ===============

glide.autocmds.create("ModeChanged", "*", ({ new_mode }) => {
	let color = null;

	switch (new_mode) {
		case "insert":
			color = "#d8b9e7";
			break;

		case "normal":
			color = "#f2f3f4";
			break;

		case "command":
			color = "#b9c8e7";
			break;

		case "hint":
			color = "#fffacd";
			break;
	}

	if (color) {
		browser.theme.update({ colors: { frame: color } });
	}
});

interface TabInfo {
	tabId: number;
	url: string;
}

class TabTracker {
	private currentTab: TabInfo | null = null;
	private latestTab: TabInfo | null = null;

	constructor() {
		glide.autocmds.create("UrlEnter", /.+/, (event) => {
			this.update(event.tab_id, event.url);
		});
	}

	public update(tabId: number, url: string): void {
		if (this.currentTab && this.currentTab.tabId === tabId) {
			this.currentTab.url = url;
			return;
		}

		if (this.currentTab) {
			this.latestTab = this.currentTab;
		}

		this.currentTab = { tabId, url };
	}

	public getLatest(): TabInfo | null {
		return this.latestTab;
	}
}

const tabTracker = new TabTracker();

// =============== KEYMAPS ===============

glide.keymaps.set(
	"normal",
	"<Space><Tab>",
	() => glide.excmds.execute("tab_next"),
	{ description: "leader + tab to cycle tabs" },
);

glide.keymaps.set("normal", "<C-n>", () => glide.excmds.execute("tab_next"), {
	description: "crl + n to cycle tabs",
});

glide.keymaps.set("insert", "<C-n>", () => glide.excmds.execute("tab_next"), {
	description: "crl + n to cycle tabs",
});

glide.keymaps.set("normal", "<Space>t", () => glide.excmds.execute("commandline_show tab "), {
	description: "tab picker",
});


// =============== TABS ===============

async function go_to_tab(url: string) {
	const tab = await glide.tabs.get_first({ url });
	assert(tab && tab.id);

	await browser.tabs.update(tab.id, { active: true });
}

glide.keymaps.set(
	"normal",
	"<Space><Space>",
	async () => {
		const tab = tabTracker.getLatest();

		if (tab) {
			await browser.tabs.update(tab.tabId, { active: true });
		}
	},
	{
		description: "switch to latest tab",
	},
);

// =============== Sites ===============

glide.autocmds.create("UrlEnter", {
  hostname: "youtube.com",
}, () => {
  glide.buf.keymaps.del("normal", "<Space>");
  glide.buf.keymaps.del("normal", "j");
  glide.buf.keymaps.del("normal", "k");
  glide.buf.keymaps.del("normal", "f");
});


// =============== Looks ===============

function applyTabStyles(): void {
  const STYLE_ID = "custom-tab-styles";

  const existingStyle = document.getElementById(STYLE_ID);
  if (existingStyle) {
    return;
  }

  const style = document.createElement("style");
  style.id = STYLE_ID;
  style.textContent = `
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
      background: pink !important;
    }
  `;

  const head = document.head;
  if (head) {
    head.appendChild(style);
  } else {
    const docEl = document.documentElement;
    if (docEl) {
      docEl.appendChild(style);
    } else {
      console.error("Could not inject custom tab styles: no suitable parent element");
    }
  }
}


glide.autocmds.create("WindowLoaded", () => {
  applyTabStyles();
});
