<?php

/* ────────────────────────────────────────────────────────────────────────── */
/*                                 CONFIG.PHP                                 */
/* ────────────────────────────────────────────────────────────────────────── */
# Specify your project's settings here

/* ─────────────────────────────── SITE_TITLE ─────────────────────────────── */
# Define the site title
$cfg["SITE_TITLE"] = "My Phakit Project";

/* ─────────────────────────────── PROTOCOL ──────────────────────────────── */
# Define the protocol
$cfg["PROTOCOL"]   = "http";

/* ─────────────────────────────── BASE_URL ──────────────────────────────── */
# Define the base URL
$cfg["BASE_URL"]   = $cfg["PROTOCOL"]."://".$_SERVER['HTTP_HOST'];

/* ──────────────────────────────── FRONTEND ──────────────────────────────── */
# Options: "tabler", "bootstrap"
$cfg["FRONTEND"]   = "tabler";

/* ────────────────────────────────── ICONS ───────────────────────────────── */
# Options: "tabler", "bootstrap"
$cfg["ICONS"]      = "bootstrap";

/* ────────────────────────────────── THEME ───────────────────────────────── */
# Options: "light", "dark"
$cfg["THEME"]      = "dark";

define("PHAKIT_CONFIG", $cfg);

?>