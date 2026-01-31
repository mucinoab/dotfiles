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

// =============== Tab Jump ===============

class TabJump {
  private readonly STYLE_ID = "tab-jump-styles";
  private readonly LABEL_CLASS = "tab-jump-label";
  private readonly KEYS = "asdfghjklqwertyuiopzxcvbnm";

  async show(): Promise<void> {
    const tabs = await browser.tabs.query({ currentWindow: true });
    if (tabs.length === 0) return;

    this.injectStyles();
    this.addLabels(tabs);

    try {
      const key = await glide.keys.next_str();
      const keyIndex = this.KEYS.indexOf(key.toLowerCase());
      const tabIndex = tabs.length - 1 - keyIndex;

      if (keyIndex >= 0 && tabIndex >= 0 && tabIndex < tabs.length) {
        const tab = tabs[tabIndex];
        if (tab.id) {
          await browser.tabs.update(tab.id, { active: true });
        }
      }
    } finally {
      this.hide();
    }
  }

  private injectStyles(): void {
    if (document.getElementById(this.STYLE_ID)) {
      return;
    }

    const style = document.createElement("style");
    style.id = this.STYLE_ID;
    style.textContent = `
      .${this.LABEL_CLASS} {
        position: absolute;
        bottom: 2px;
        left: 2px;
        background: #fffacd;
        color: #000;
        font-size: 15px !important;
        font-weight: bold;
        padding: 1px 3px;
        border-radius: 2px;
        z-index: 1000;
        pointer-events: none;
      }
    `;

    const head = document.head;
    if (head) {
      head.appendChild(style);
    } else {
      document.documentElement?.appendChild(style);
    }
  }

  private addLabels(tabs: Browser.Tabs.Tab[]): void {
    const tabElements = document.querySelectorAll(".tabbrowser-tab");
    const numTabs = Math.min(tabElements.length, tabs.length, this.KEYS.length);

    tabElements.forEach((tabEl, i) => {
      if (i >= numTabs) return;

      const label = document.createElement("span");
      label.className = this.LABEL_CLASS;
      // Last tab gets 'a', second-to-last gets 's', etc.
      label.textContent = this.KEYS[numTabs - 1 - i];

      const container = tabEl as HTMLElement;
      container.style.position = "relative";
      container.appendChild(label);
    });
  }

  private hide(): void {
    const labels = document.querySelectorAll(`.${this.LABEL_CLASS}`);
    labels.forEach((label) => label.remove());
  }
}

const tabJump = new TabJump();

glide.keymaps.set("normal", "gt", () => tabJump.show(), {
  description: "[g]o to [t]ab by letter",
});
