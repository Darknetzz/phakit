<?php

/* ────────────────────────────────────────────────────────────────────────── */
/*                                 CONFIG.PHP                                 */
/* ────────────────────────────────────────────────────────────────────────── */
# Specify your project's settings here

/* ─────────────────────────────── SITE_TITLE ─────────────────────────────── */
# Define the site title
define("SITE_TITLE", "My Website");

/* ─────────────────────────────── BASE_URL ──────────────────────────────── */
# Define the base URL
define("BASE_URL", "https://".$_SERVER['HTTP_HOST']);

/* ──────────────────────────────── FRONTEND ──────────────────────────────── */
# Options: "tabler", "bootstrap"
# Leave empty to disable
define("FRONTEND", "tabler");

/* ────────────────────────────────── THEME ───────────────────────────────── */
# Options: "light", "dark"
define("THEME", "dark");

?>