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
}, async () => {
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


// https://github.com/NonlinearFruit/dotfiles/blob/master/glide/gnarly-text-edit.ts
// Gnarly Text Edit: edit the currently focused editable element in nvim
// Features:
// - Grabs the text content of the focused <textarea>, <input>, or contenteditable
// - Dumps it to a temp markdown file
// - Opens it in nvim via wezterm and waits for the editor to exit
// - Replaces the element's content with the edited file contents
glide.excmds.create({ name: "text_edit", description: "Edit the focused editable element in nvim" }, async () => {
  if (!(await glide.ctx.is_editing())) {
    throw new Error("No editable element is focused");
  }

  const tab = await glide.tabs.active();
  const original = await glide.content.execute(read_focused_text, { tab_id: tab });

  const tempfile = await mktemp("glide_text_edit.XXXXXX");
  await glide.fs.write(tempfile, original);

  await let_user_edit_file_and_wait_for_exit(tempfile);

  let edited = await glide.fs.read(tempfile, "utf8");
  // `glide.fs.write` above does not append a trailing newline, but many editors
  // (including nvim) will add one on save. Strip a single trailing newline so
  // round-tripping an unchanged buffer is a no-op.
  if (edited.endsWith("\n") && !original.endsWith("\n")) {
    edited = edited.slice(0, -1);
  }

  await glide.content.execute(write_focused_text, { tab_id: tab, args: [edited] });
});

glide.keymaps.set(["normal", "insert"], "<C-x><C-e>", "text_edit", {
  description: "Edit the focused editable element in nvim",
});

async function let_user_edit_file_and_wait_for_exit(tempfile) {
  const edit_cmd = await glide.process.execute("wezterm", [
    "start",
    "--",
    "nvim",
    tempfile,
  ]);
  const edit_result = await edit_cmd.wait();
  if (edit_result.exit_code !== 0) {
    throw new Error(`Editor command failed with exit code ${edit_result.exit_code}`);
  }
}

async function mktemp(template) {
  const mktemp_cmd = await glide.process.execute("mktemp", ["-t", template, "--suffix", ".md"]);
  return (await mktemp_cmd.stdout.text()).trim();
}

// --- Content-process helpers ---------------------------------------------

function read_focused_text(): string {
  const el = document.activeElement as HTMLElement | null;
  if (!el) return "";
  if (el instanceof HTMLTextAreaElement || el instanceof HTMLInputElement) {
    return el.value ?? "";
  }
  if ((el as HTMLElement).isContentEditable) {
    // innerText preserves visible line breaks better than textContent
    return (el as HTMLElement).innerText ?? "";
  }
  return "";
}

function write_focused_text(text: string): void {
  const el = document.activeElement as HTMLElement | null;
  if (!el) return;

  if (el instanceof HTMLTextAreaElement || el instanceof HTMLInputElement) {
    // Use the native value setter so frameworks like React pick up the change.
    const proto =
      el instanceof HTMLTextAreaElement
        ? HTMLTextAreaElement.prototype
        : HTMLInputElement.prototype;
    const setter = Object.getOwnPropertyDescriptor(proto, "value")?.set;
    if (setter) {
      setter.call(el, text);
    } else {
      el.value = text;
    }
    el.dispatchEvent(new Event("input", { bubbles: true }));
    el.dispatchEvent(new Event("change", { bubbles: true }));
    return;
  }

  if (el.isContentEditable) {
    // Prefer execCommand so the site's undo stack / input listeners fire.
    el.focus();
    const sel = el.ownerDocument.getSelection();
    if (sel) {
      const range = el.ownerDocument.createRange();
      range.selectNodeContents(el);
      sel.removeAllRanges();
      sel.addRange(range);
    }
    if (!document.execCommand("insertText", false, text)) {
      el.innerText = text;
      el.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertText", data: text }));
    }
  }
}
