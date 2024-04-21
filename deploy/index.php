<?php
    require_once('config.php');
?>

<!DOCTYPE html>
<html data-bs-theme="<?= THEME ?>">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">

        <title><?= SITE_TITLE ?></title>

        <?php
            if (defined('FRONTEND')) {
                echo '<script src="js/jquery.min.js"></script>';
                if (FRONTEND == 'tabler') {
                    echo '<script src="js/tabler.min.js"></script>';
                    echo '<link href="css/tabler.min.css" rel="stylesheet" />';
                } elseif (FRONTEND == 'bootstrap') {
                    echo '<script src="js/bootstrap.bundle.min.js"></script>';
                    echo '<link href="css/bootstrap.min.css" rel="stylesheet" />';
                } else {
                    echo '<!-- Frontend not found -->';
                }
            }
        ?>

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