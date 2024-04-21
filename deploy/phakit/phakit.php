<?php

if (!file_exists('config.php')) {
    die('Please create a config.php file in the phakit directory.');
}

require_once('config.php');

if (!defined('PHAKIT_CONFIG')) {
    die('Please define the PHAKIT_CONFIG constant in the config.php file.');
}

class Phakit {

    /* ────────────────────────────────────────────────────────────────────────── */
    /*                                 __construct                                */
    /* ────────────────────────────────────────────────────────────────────────── */
    function __construct() {

        $this->config = PHAKIT_CONFIG;

        if (!empty($this->config['FRONTEND'])) {
            echo '<script src="js/jquery.min.js"></script>';
            echo '<script src="js/'.$this->config['FRONTEND'].'.min.js"></script>';
            echo '<link href="css/'.$this->config['FRONTEND'].'.min.css" rel="stylesheet" />';
        }

        if (!empty($this->config['ICONS'])) {
            echo '<link href="css/'.$this->config['ICONS'].'-icons.min.css" rel="stylesheet" />';
        }
    }

    /* ────────────────────────────────────────────────────────────────────────── */
    /*                                    icon                                    */
    /* ────────────────────────────────────────────────────────────────────────── */
    function icon($icon = '') {
        if (!empty($this->config['ICONS'])) {
            if ($this->config['ICONS'] == 'tabler') {
                return '<i class="ti ti-'.$icon.'"></i>';
            } else if ($this->config['ICONS'] == 'bootstrap') {
                return '<i class="bi bi-'.$icon.'"></i>';
            }
        }
    }

    /* ────────────────────────────────────────────────────────────────────────── */
    /*                                    alert                                   */
    /* ────────────────────────────────────────────────────────────────────────── */
    function alert($type = 'info', $message = '') {
        return '<div class="alert alert-'.$type.' alert-dismissible fade show" role="alert">
                    '.$message.'
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>';
    }

}


?>