<?php
    require_once('phakit/config.php');
    require_once('phakit/phakit.php');
    define("PHAKIT", new Phakit());
?>

<!DOCTYPE html>
<html data-bs-theme="<?= PHAKIT_CONFIG['THEME'] ?>">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <title><?= PHAKIT_CONFIG['SITE_TITLE'] ?></title>

    </head>

    <body>
    <?php
        if (isset($_GET['page'])) {
            $page = $_GET['page'];
        } else {
            $page = 'home';
        }

        if (file_exists('pages/' . $page . '.php')) {
            include('pages/' . $page . '.php');
        } else {
            include('pages/404.php');
        }
    ?>
    </body>

</html>