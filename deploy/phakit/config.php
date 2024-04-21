<?php

/* ────────────────────────────────────────────────────────────────────────── */
/*                                 CONFIG.PHP                                 */
/* ────────────────────────────────────────────────────────────────────────── */
# Specify your project's settings here

define("PHAKIT_CONFIG", 
[
    /* ─────────────────────────────── SITE_TITLE ─────────────────────────────── */
    # Define the site title
    "SITE_TITLE" => "My Phakit Project",

    /* ─────────────────────────────── BASE_URL ──────────────────────────────── */
    # Define the base URL
    "BASE_URL" => "https://".$_SERVER['HTTP_HOST'],

    /* ──────────────────────────────── FRONTEND ──────────────────────────────── */
    # Options: "tabler", "bootstrap"
    "FRONTEND" => "tabler",

    /* ────────────────────────────────── ICONS ───────────────────────────────── */
    # Options: "tabler", "bootstrap"
    "ICONS" => "tabler",

    /* ────────────────────────────────── THEME ───────────────────────────────── */
    # Options: "light", "dark"
    "THEME" => "dark"
]
);

?>