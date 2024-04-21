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
                    echo '<script src="js/'.FRONTEND.'.min.js"></script>';
                    echo '<link href="css/'.FRONTEND.'.min.css" rel="stylesheet" />';
            }

            if (defined('ICONS')) {
                echo '<link href="css/'.ICONS.'-icons.min.css" rel="stylesheet" />';
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