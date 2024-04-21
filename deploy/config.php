<?php

/* ────────────────────────────────────────────────────────────────────────── */
/*                                 CONFIG.PHP                                 */
/* ────────────────────────────────────────────────────────────────────────── */
# Specify your project's settings here
# Define the site title and base URL
define("SITE_TITLE", "My Website");
define("BASE_URL", "https://".$_SERVER['HTTP_HOST']);

# Define the frontend
# Options: "tabler", "bootstrap"
# Leave empty to disable
define("FRONTEND", "tabler");

?>